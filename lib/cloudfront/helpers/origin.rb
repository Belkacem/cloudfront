# encoding: UTF-8

class Cloudfront
  module Helpers
    class Origin 
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer
      
      attr_accessor :id,
                    :domain_name,
                    :origin_access_identity,
                    :http_port,
                    :https_port,
                    :origin_protocol_policy

      def initialize(params = {}, &block)
        @id = params[:id]
        @domain_name = params[:domain_name] unless
        @origin_access_identity = params[:origin_access_identity]
        @http_port = params[:http_port] || 80
        @https_port = params[:http_ports] || 443
        @origin_protocol_policy = params[:origin_protocol_policy] || "match-viewer"
        #set value from block
        instance_eval &block if block_given?
      end

      def validate
        error_messages.push "http_port is invalid" unless @http_port.between?(0, 65535)
        error_messages.push "https_port is invalid" unless @https_port.between?(0, 65535)
        error_messages.push "id can't be null" if @id.nil?
        error_messages.push "origin_protocol_policy is invalid should be in #{Cloudfront::Utils::Util::MATCH_VIEWER_VALUES.join(', ')}" unless Cloudfront::Utils::Util::MATCH_VIEWER_VALUES.include?(@origin_protocol_policy)
      end
      
      # {
      #     "Origin"=> {
      #         "Id"=>"unique identifier for this origin",
      #         "DomainName"=>"domain name of origin",
      #         "S3OriginConfig"=> {
      #             "OriginAccessIdentity"=> "origin-access-identity/cloudfront/ID"
      #         },
      #         "CustomOriginConfig"=> {
      #             "HTTPPort"=> 80,
      #             "HTTPSPort"=> 443,
      #            "OriginProtocolPolicy"=>"match-viewer"
      #         }
      #     }
      # }
      def self.from_hash(hash)
        hash = hash["Origin"] || hash
        self.new do
          self.id = hash["Id"]
          self.domain_name = hash["DomainName"]
          if hash.has_key? "S3OriginConfig"
            self.origin_access_identity = hash["S3OriginConfig"]["OriginAccessIdentity"]
          else
            custom_origin_config = hash["CustomOriginConfig"]
            if custom_origin_config
              self.http_port = (custom_origin_config["HTTPPort"] || "80").to_i
              self.https_port = (custom_origin_config["HTTPSPort"] || "443").to_i
              self.origin_protocol_policy = custom_origin_config["OriginProtocolPolicy"] || "match-viewer"
            end
          end
        end
      end

      # The origin class container
      #      <Origin>
      #        <Id>unique identifier for this origin</Id>
      #        <DomainName>domain name of origin</DomainName>
      #        <!-- Include the S3OriginConfig element only if you use an Amazon S3 origin for your distribution. -->
      #        <S3OriginConfig>
      #          <OriginAccessIdentity>origin-access-identity/cloudfront/ID</OriginAccessIdentity>
      #        </S3OriginConfig>
      #        <!-- Include the CustomOriginConfig element only if you use a custom origin for your distribution. -->
      #        <CustomOriginConfig>
      #          <HTTPPort>80</HTTPPort>
      #          <HTTPSPort>443</HTTPSPort>
      #          <OriginProtocolPolicy>http-only |
      #            match-viewer</OriginProtocolPolicy>
      #        </CustomOriginConfig>
      #      </Origin>
      def build_xml(xml)
        check_configuration
        xml.Origin {
          xml.Id @id
          xml.DomainName @domain_name
          if (!@origin_access_identity.nil?)
            xml.S3OriginConfig {
              xml.OriginAccessIdentity @origin_access_identity
            }
          else
            xml.CustomOriginConfig {
              xml.HTTPPort @http_port
              xml.HTTPSPort @https_port
              xml.OriginProtocolPolicy @origin_protocol_policy
            }
          end
        }
      end

    end
  end
end
