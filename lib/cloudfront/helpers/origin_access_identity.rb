# encoding: UTF-8

class Cloudfront
  module Helpers
    class OriginAccessIdentity
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :caller_reference,
                    :comment

      def initialize(&block)
        #setting default values
        @caller_reference = Cloudfront::Utils::Util.generate_caller_reference
        @comment = "Created with cloudfront Gem, visit https://github.com/Belkacem/cloudfront"

        #set value from block
        instance_eval &block if block_given?
      end

      def validate
        this = self

        # Error checking
        error_messages.push "The caller_reference shouldn't be empty" if @caller_reference.empty?
      end

      #{
      #    "CloudFrontOriginAccessIdentityConfig" => {
      #        "CallerReference" => "ref",
      #        "Comment" => "The comment."
      #    }
      #}
      def self.from_hash(hash)
        hash = hash["CloudFrontOriginAccessIdentityConfig"] || hash
        self.new do
          self.caller_reference = hash["CallerReference"]
          self.comment = hash["Comment"]
        end
      end

      #<?xml version="1.0" encoding="UTF-8"?>
      #<CloudFrontOriginAccessIdentityConfig xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/">
      #   <CallerReference>ref</CallerReference>
      #   <Comment>The comment.</Comment>
      #</CloudFrontOriginAccessIdentityConfig>

      def build_xml(xml)
        check_configuration
        xml.CloudFrontOriginAccessIdentityConfig('xmlns' => "http://cloudfront.amazonaws.com/doc/#{Cloudfront::Utils::Api.version}/") {
          xml.CallerReference @caller_reference
          xml.Comment @comment
        }
      end

    end
  end
end
