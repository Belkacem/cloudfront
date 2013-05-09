# encoding: UTF-8

require_relative 'origin'

class Cloudfront
  module Helpers
    class Origins 
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :origins

      def initialize(&block)
        #set default values
        @origins = []

        #set values from block
        instance_eval &block if block_given?
      end

      def validate
        # put origin in a list (this is done for single origin distributions)
        @origins = [@origins] unless @origins.is_a? Array
        
        for origin in @origins
          if origin.is_a?(Origin)
            origin.check_configuration
          end
        end
      end

      # {
      #     "Origins" => {
      #         "Quantity" => "2",
      #         "Items" => {
      #             "Origin" => [
      #                 {
      #                     "Id" => "example-Amazon S3-origin",
      #                     "DomainName" => "myawsbucket.s3.amazonaws.com",
      #                     "S3OriginConfig" => {
      #                         "OriginAccessIdentity" => "origin-access-identity/cloudfront/E74FTE3AEXAMPLE"
      #                     }
      #                 },
      #                 {
      #                     "Id" => "example-custom-origin",
      #                     "DomainName" => "example.com",
      #                     "CustomOriginConfig" => {
      #                         "HTTPPort" => "80",
      #                         "HTTPSPort" => "443",
      #                         "OriginProtocolPolicy" => "match-viewer"
      #                     }
      #                 }
      #             ]
      #         }
      #     }
      # }
      def self.from_hash(hash)
        hash = hash["Origins"] || hash
        self.new do
          unless hash["Items"].nil?
            origins_list = hash["Items"]["Origin"].is_a?(Hash) ? [hash["Items"]["Origin"]] : hash["Items"]["Origin"]
            for origin_hash in origins_list
              unless origin_hash.nil?
                self.origins.push(Origin.from_hash(origin_hash))
              end
            end
          end
        end
      end

      # <Origins>
      #  <Quantity>number of origins</Quantity>
      #  <Items>
      #     ... see Origin class
      #   </Items>
      # </Origins>
      #
      def build_xml(xml)
        check_configuration
        xml.Origins {
          xml.Quantity @origins.size
          if @origins.size > 0
            xml.Items {
              for origin in @origins
                origin.build_xml(xml)
              end
            }
          end
        }
      end

    end
  end
end
