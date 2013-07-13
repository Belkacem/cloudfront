# encoding: UTF-8

require_relative 's3_origin'
require_relative 'aliases'
require_relative 'logging'
require_relative 'trusted_signers'

class Cloudfront
  module Helpers
    class StreamingDistribution
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :caller_reference,
                    :domain_name,
                    :origin_access_identity,
                    :cnames,
                    :comment,
                    :logging,
                    :trusted_signers,
                    :price_class,
                    :enabled

      def initialize(params = {}, &block)
        @caller_reference = params[:caller_reference] || Cloudfront::Utils::Util.generate_caller_reference
        @s3_origin = params[:s3_origin]
        @domain_name = params[:domain_name]
        @origin_access_identity = params[:origin_access_identity]
        @cnames = params[:cnames] || []
        @comment = params[:comment] || "Created with cloudfront Gem, visit https://github.com/Belkacem/cloudfront"
        @logging = params[:logging] || Logging.new
        @trusted_signers = params[:trusted_signers] || []
        @price_class = params[:price_class] || "PriceClass_All"
        @enabled = params[:enabled] || false

        #set value from block
        instance_eval &block if block_given?
      end

      def validate
        this = self

        # s3_origin, aliases and trusted_signers_container are internal structures.
        if @s3_origin.nil? || !@s3_origin.is_a?(S3Origin)
          @s3_origin = S3Origin.new do
            self.domain_name = this.domain_name
            self.origin_access_identity = this.origin_access_identity
          end
        end

        @aliases = Aliases.new do
          self.cnames = this.cnames
        end

        @trusted_signers_container = TrustedSigners.new do
          #self.enabled = true
          self.trusted_signers = this.trusted_signers
        end

        @logging.include_cookies = "undefined"
        
        # Error checking
        error_messages.push "The caller_reference shouldn't be empty" if @caller_reference.empty?
        @s3_origin.check_configuration
        @aliases.check_configuration
        @logging.check_configuration
        @trusted_signers_container.check_configuration

        error_messages.push "price_class is invalid should be in #{Cloudfront::Utils::Util::PRICE_CLASS.join(', ')}" unless Cloudfront::Utils::Util::PRICE_CLASS.include?(@price_class)
        error_messages.push "enabled should be a boolean" unless !!@enabled == @enabled
      end
      
      # Creates a distribution configuration wrapper from a hash
      # {
      #     "StreamingDistributionConfig" => {
      #         "CallerReference" => "unique description for this distribution",
      #         "S3Origin" => {
      #           ... see s3Origin
      #         },
      #         "Aliases" => {
      #             "Quantity" => "number of CNAME aliases",
      #             "Items" => {
      #                 "CNAME" => "CNAME alias"
      #             }
      #         },
      #         "Comment" => "comment about the distribution",
      #         "Logging" => {
      #             "Enabled" => "true | false",
      #             "Bucket" => "Amazon S3 bucket for logs",
      #             "Prefix" => "prefix for log file names"
      #         },
      #         "TrustedSigners" => {
      #             "Quantity" => "number of trusted signers",
      #             "Items" => {
      #                 "AwsAccountNumber" => "self | AWS account that can create \n            signed URLs"
      #             }
      #         },
      #         "PriceClass" => "maximum price class for the distribution",
      #         "Enabled" => "true | false"
      #     }
      # }
      def self.from_hash(hash)
        hash = hash["StreamingDistributionConfig"] || hash
        self.new do
          self.caller_reference = hash["CallerReference"]
          origin = S3Origin.from_hash(hash)
          self.domain_name = origin.domain_name
          self.origin_access_identity = origin.origin_access_identity
          self.cnames = Aliases.from_hash(hash).cnames # Aliases class contains the code that extract cnames
          self.comment = hash["Comment"]
          self.logging = Logging.from_hash(hash)
          self.trusted_signers = TrustedSigners.from_hash(hash).trusted_signers
          self.price_class = hash["PriceClass"] || "PriceClass_All"
          self.enabled = (hash["Enabled"] || "false").to_bool
        end
      end

      #<StreamingDistributionConfig xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/">
      #   <CallerReference>unique description for this distribution</CallerReference>
      #   <S3Origin>
      #      <DNSName>CloudFront domain name assigned to the distribution</DNSName>
      #      <OriginAccessIdentity>origin-access-identity/cloudfront/ID</OriginAccessIdentity>
      #   </S3Origin>
      #   <Aliases>
      #      ... see Aliases class
      #   </Aliases>
      #   <Comment>comment about the distribution</Comment>
      #   <Logging>
      #      ... see Logging class.
      #   </Logging>
      #   <TrustedSigners>
      #      ... see TrustedSigners.
      #   </TrustedSigners>
      #   <PriceClass>maximum price class for the distribution</PriceClass>
      #   <Enabled>true | false</Enabled>
      #</StreamingDistributionConfig>
      def build_xml(xml)
        check_configuration
        xml.StreamingDistributionConfig('xmlns' => "http://cloudfront.amazonaws.com/doc/#{Cloudfront::API_VERSION}/") {
          xml.CallerReference @caller_reference
          @s3_origin.build_xml(xml)
          @aliases.build_xml(xml)
          xml.Comment @comment
          @logging.build_xml(xml)
          @trusted_signers_container.build_xml(xml)
          xml.PriceClass @price_class
          xml.Enabled @enabled
        }
      end

    end
  end
end
