# encoding: UTF-8

require_relative 'trusted_signers'
require_relative 'cache_behavior'

class Cloudfront
  module Helpers
    class CacheBehaviors
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :cache_behaviors

      def initialize(cache_behaviors = [], &block)
        @cache_behaviors = cache_behaviors

        #set values from block
        instance_eval &block if block_given?
      end

      def validate
        # some wrapping
        @cache_behaviors = Array.wrap @cache_behaviors

        # Error checking
        for cache_behavior in @cache_behaviors
          if cache_behavior.is_a?(CacheBehavior)
            cache_behavior.check_configuration
          else
            error_messages.push "cache_behaviors list contains a non CacheBehavior element #{cache_behavior}"
          end
        end
      end

      # hash = {
      #     "CacheBehaviors" => {
      #         "Quantity" => "2",
      #         "Items" => {
      #             "CacheBehavior" => [
      #                 {
      #                     #see CacheBehavior
      #                 }, {
      #                     #...
      #                 }
      #             ]
      #         }
      #     }
      # }
      def self.from_hash(hash)
        hash = hash["CacheBehaviors"] || hash
        self.new do
          for cache_behavior in [(hash["Items"]|| {})["CacheBehavior"]]
            unless cache_behavior.nil?
              self.cache_behaviors.push(CacheBehavior.from_hash(cache_behavior))
            end
          end
        end
      end

      # The cache behavior class container
      # <CacheBehaviors>
      #    <Quantity>1</Quantity>
      #    <Items>
      #      <CacheBehavior>
      #        <PathPattern>pattern that specifies files that this cache behavior applies to</PathPattern>
      #        <TargetOriginId>ID of the origin that this cache behavior applies to</TargetOriginId>
      #        <ForwardedValues>
      #          <QueryString>true | false</QueryString>
      #          <Cookies>
      #            <Forward>all | whitelist | none</Forward>
      #            <!-- Required when Forward = whitelist, omitted otherwise. -->
      #            <WhitelistedNames>
      #              <Quantity>number of cookie names to forward to origin</Quantity>
      #              <Items>
      #                <Name>name of a cookie to forward to the origin</Name>
      #              </Items>
      #            </WhitelistedNames>
      #          </Cookies>
      #        </ForwardedValues>
      #        <TrustedSigners>
      #          ... see TrustedSigners class
      #        </TrustedSigners>
      #        <ViewerProtocolPolicy>allow-all | https-only</ViewerProtocolPolicy>
      #        <MinTTL>minimum TTL in seconds for files specified by PathPattern</MinTTL>
      #      </CacheBehavior>
      def build_xml(xml)
      check_configuration
        xml.CacheBehaviors {
          xml.Quantity @cache_behaviors.size
          if @cache_behaviors.size > 0
            xml.Items {
              for cache_behavior in @cache_behaviors
                cache_behavior.build_xml(xml)
              end
            }
          end
        }
      end

    end
  end
end





