# encoding: UTF-8

require_relative 'logging'
require_relative 'origins'
require_relative 'aliases'
require_relative 'cache_behavior'
require_relative 'cache_behaviors'

class Cloudfront
  module Helpers
    class DownloadDistribution
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :caller_reference,
                    :cnames,
                    :default_root_object,
                    :origins,
                    :default_cache_behavior,
                    :cache_behaviors,
                    :comment,
                    :logging,
                    :price_class,
                    :enabled

      def initialize(params = {}, &block)
        @caller_reference = params[:caller_reference] || Cloudfront::Utils::Util.generate_caller_reference
        @cnames = params[:cnames] || []
        @default_root_object = params[:default_root_object] || "/index.html"
        @origins = params[:origins] || []
        @default_cache_behavior = params[:default_cache_behavior] || CacheBehavior.new do
          self.is_default = true
        end
        @cache_behaviors = params[:cache_behaviors] || []
        @comment = params[:comment] || "Created with cloudfront Gem, visit https://github.com/Belkacem/cloudfront"
        @logging = params[:logging] || Logging.new
        @price_class = params[:price_class] ||"PriceClass_All"
        @enabled = params[:enabled] || false

        #set value from block
        instance_eval &block if block_given?
      end

      def validate
        init_internals
        # Error checking
        error_messages.push "The caller_reference shouldn't be empty" if @caller_reference.empty?
        @aliases.check_configuration
        @origins_container.check_configuration
        @default_cache_behavior.check_configuration
        # Making the default cache behavior to true
        @default_cache_behavior.is_default = true
        @behaviors.check_configuration
        @logging.check_configuration
        error_messages.push "price_class is invalid should be in #{Cloudfront::Utils::Util::PRICE_CLASS.join(', ')}" unless Cloudfront::Utils::Util::PRICE_CLASS.include?(@price_class)
        error_messages.push "enabled should be a boolean" unless !!@enabled == @enabled
      end
      
      def init_internals
        this = self

        # aliases and behaviors are internal structures.
        @aliases = Aliases.new do
          self.cnames = this.cnames
        end

        @behaviors = CacheBehaviors.new do
          self.cache_behaviors = this.cache_behaviors
        end

        @origins_container = Origins.new do
          self.origins = this.origins
        end
      end
      
      # Creates a distribution configuration wrapper from a hash
      # {
      #   "DistributionConfig" => {
      #       "CallerReference" => "unique description for this distribution config",
      #       "Aliases" => "Aliases class",
      #       "DefaultRootObject" => "URL for default root object",
      #       "Origins" => ... see Origins class",
      #       "DefaultCacheBehavior" =>
      #           "\n... see CacheBehaviour class\n                       ",
      #       "CacheBehaviors" => {
      #          ... see CacheBehaviors
      #        },
      #       "Comment" => "comment about the distribution",
      #       "Logging" =>
      #             "... see Logging class",
      #       "PriceClass" => "maximum price class for the distribution",
      #       "Enabled" => "true | false"
      #   }
      # }
      def self.from_hash(hash)
        hash = hash["DistributionConfig"] || hash
        self.new do
          self.caller_reference = hash["CallerReference"]
          self.cnames = Aliases.from_hash(hash["Aliases"]).cnames # Aliases class contains the code that extract cnames
          self.default_root_object = hash["DefaultRootObject"]
          self.origins = Origins.from_hash(hash["Origins"]).origins
          self.default_cache_behavior = CacheBehavior.from_hash(hash["DefaultCacheBehavior"])
          self.cache_behaviors = CacheBehaviors.from_hash(hash["CacheBehaviors"]).cache_behaviors
          self.comment = hash["Comment"]
          self.logging = Logging.from_hash(hash["Logging"])
          self.price_class = hash["PriceClass"] || "PriceClass_All"
          self.enabled = (hash["Enabled"] || "false").to_bool
        end
      end

      #<?xml version="1.0" encoding="UTF-8"?>
      #<DistributionConfig xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/">
      #  <CallerReference>unique description for this distribution config</CallerReference>
      #  <Aliases>
      #    ... see Alias class
      #  </Aliases>
      #  <DefaultRootObject>URL for default root object</DefaultRootObject>
      #  <Origins>
      #    <Quantity>number of origins</Quantity>
      #    <Items>
      #       ... see Origin class
      #    </Items>
      #  </Origins>
      #  <DefaultCacheBehavior>
      #      ... see CacheBehaviour class
      #  </DefaultCacheBehavior>
      #  <CacheBehaviors>
      #    <Quantity>number of cache behaviors</Quantity>
      #    <!-- Optional. Omit when Quantity = 0. -->
      #    <Items>
      #      ... see CacheBehaviour class
      #    </Items>
      #  </CacheBehaviors>
      #  <Comment>comment about the distribution</Comment>
      #  <Logging>
      #    ... see Logging class
      #  </Logging>
      #  <PriceClass>maximum price class for the distribution</PriceClass>
      #  <Enabled>true | false</Enabled>
      #</DistributionConfig>
      def build_xml(xml)
        check_configuration
        xml.DistributionConfig('xmlns' => "http://cloudfront.amazonaws.com/doc/#{Cloudfront::API_VERSION}/") {
          xml.CallerReference @caller_reference
          @aliases.build_xml(xml)
          xml.DefaultRootObject @default_root_object
          @origins_container.build_xml(xml)
          @default_cache_behavior.build_xml(xml)
          @behaviors.build_xml(xml)
          xml.Comment @comment
          @logging.build_xml(xml)
          xml.PriceClass @price_class
          xml.Enabled @enabled
        }
      end

    end
  end
end
