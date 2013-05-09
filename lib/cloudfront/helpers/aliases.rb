# encoding: UTF-8

class Cloudfront
  module Helpers
    class Aliases
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :cnames

      def initialize(&block)
        #set default values
        @cnames = []

        #set values from block
        instance_eval &block if block_given?
      end

      def validate
        # some wrapping
        @cnames = Array.wrap @cnames # wraps single elements into an array and removes nil parasites


        # Some additional checking should be done on cnames.
        for cname in cnames
          error_messages.push("#{cname} isn't a valid url") unless cname =~  Cloudfront::Utils::Util::URL_REGEXP
        end
      end

      # A factory method that creates a Aliases instance from a hash
      # Input example
      # hash = {
      #     "Aliases" => {
      #         "Quantity" => "number of CNAME cnames",
      #         "Items" => {
      #             "CNAME" => "CNAME alias"
      #         }
      #     }
      # }
      #
      def self.from_hash(hash)
        hash = hash["Aliases"] || hash
        self.new do
          self.cnames = Array.wrap((hash["Items"] || {})["CNAME"])
        end
      end

      # Output example
      # <Aliases>
      #   <Quantity>number of CNAME cnames</Quantity>
      #   <Items>
      #     <CNAME>CNAME alias</CNAME>
      #   </Items>
      # </Aliases>
      def build_xml(xml)
        check_configuration
        xml.Aliases {
          xml.Quantity @cnames.size
          if @cnames.size > 0
            xml.Items {
              for cname in Array.wrap @cnames
                xml.CNAME cname
              end
            }
          end
        }
      end

    end
  end
end
