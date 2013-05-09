# encoding: UTF-8

class Cloudfront
  module Helpers
    class S3Origin
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer
      
      attr_accessor :domain_name,
                    :origin_access_identity

      def initialize(&block)
        #set value from block
        instance_eval &block if block_given?
      end

      def validate
        error_messages.push "domain_name can't be null" if @domain_name.nil?
        error_messages.push "origin_access_identity can't be null" if @origin_access_identity.nil?
      end
      
      # {
      #   "S3Origin" => {
      #     "DomainName" => "CloudFront domain name assigned to the distribution",
      #     "OriginAccessIdentity" => "origin-access-identity/cloudfront/ID"
      #   }
      # }
      def self.from_hash(hash)
        hash = hash["S3Origin"] || hash
        self.new do
          self.domain_name = hash["DomainName"]
          self.origin_access_identity = hash["OriginAccessIdentity"]
        end
      end

      # The origin class container
      #   <S3Origin>
      #      <DomainName>CloudFront domain name assigned to the distribution</DNSName>
      #      <OriginAccessIdentity>origin-access-identity/cloudfront/ID</OriginAccessIdentity>
      #   </S3Origin>
      def build_xml(xml)
        check_configuration
        xml.S3Origin {
          xml.DomainName @domain_name unless @domain_name.nil?
          xml.OriginAccessIdentity @origin_access_identity
        }
      end

    end
  end
end
