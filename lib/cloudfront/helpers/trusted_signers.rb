# encoding: UTF-8

class Cloudfront
  module Helpers
    class TrustedSigners
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :enabled,
                    :trusted_signers

      def initialize(&block)
        #set default values
        @enabled = false
        @trusted_signers = []

        #set values from block
        instance_eval &block if block_given?
      end

      def validate
        @trusted_signers = Array.wrap @trusted_signers
        @trusted_signers.push "self" unless @trusted_signers.include? "self"
      end

      # A factory method that creates a TrustedSigners instance from a hash
      # Input example
      # hash = {
      #     "TrustedSigners" => {
      #         "Enabled" => "true | false",
      #         "Quantity" => "number of trusted signers",
      #         "Items" => {
      #             "AwsAccountNumber" => "self | AWS account that can create signed URLs"
      #         }
      #     }
      # }
      #
      def self.from_hash(hash)
        hash = hash["TrustedSigners"] || hash
        self.new do
          self.enabled = hash["Enabled"].nil? ? nil : hash["Enabled"].to_bool
          if (hash["Quantity"]|| "0").to_i > 0
            self.trusted_signers = Array.wrap((hash["Items"]|| {})["AwsAccountNumber"])
          end
        end
      end

      # Output example
      #  <TrustedSigners>
      #    <Enabled>true</Enabled>
      #    <Quantity>number of trusted signers</Quantity>
      #    <Items>
      #      <AwsAccountNumber>self</AwsAccountNumber>
      #    </Items>
      #  </TrustedSigners>
      def build_xml(xml)
        check_configuration
        xml.TrustedSigners {
          xml.Enabled (@enabled || @trusted_signers.any?)
          xml.Quantity @trusted_signers.size
          if @trusted_signers.any?
            xml.Items {
              for signer in @trusted_signers
                xml.AwsAccountNumber signer
              end
            }
          end
        }
      end

    end
  end
end
