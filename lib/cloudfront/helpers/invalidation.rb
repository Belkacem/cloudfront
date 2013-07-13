# encoding: UTF-8

require 'cloudfront/helpers/invalidation'

class Cloudfront
  module Helpers
    class Invalidation
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :caller_reference,
                    :files

      def initialize(params = {}, &block)
        @caller_reference = params[:caller_reference] || Cloudfront::Utils::Util.generate_caller_reference
        @files = params[:files] || []

        #set value from block
        instance_eval &block if block_given?
      end

      def validate
        @files = Array.wrap @files

        # Error checking
        error_messages.push "files shouldn't be empty" unless @files.any?
        for file in @files
          error_messages.push "the file '#{file}' isn't valid, it should start with '/'" unless file.start_with? '/'
        end
      end
      
      # Creates a Invalidation from a hash
      # {
      #     "InvalidationBatch" => {
      #                   "Paths" => {
      #             "Quantity" => "number of objects to invalidate",
      #                "Items" => {
      #                 "Path" => "/path to object to invalidate"
      #             }
      #         },
      #         "CallerReference" => "unique identifier for this invalidation batch"
      #     }
      # }
      def self.from_hash(hash)
        hash = hash["InvalidationBatch"] || hash
        self.new do
          self.caller_reference = hash["CallerReference"]
          items = (hash["Paths"] || {})["Items"]
          self.files = Array.wrap (items["Path"])
        end
      end

      # <?xml version="1.0" encoding="UTF-8"?>
      # <InvalidationBatch xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/">
      #    <Paths>
      #       <Quantity>number of objects to invalidate</Quantity>
      #       <Items>
      #          <Path>/path to object to invalidate</Path>
      #       </Items>
      #    </Paths>
      #    <CallerReference>unique identifier for this invalidation batch</CallerReference>
      # </InvalidationBatch>
      def build_xml(xml)
        check_configuration
        xml.InvalidationBatch('xmlns' => "http://cloudfront.amazonaws.com/doc/#{Cloudfront::API_VERSION}/") {
          xml.Paths {
            xml.Quantity @files.size
            if @files.size > 0
              xml.Items {
                for file in Array.wrap @files
                  xml.Path file
                end
              }
            end
          }
          xml.CallerReference @caller_reference
        }
      end

    end
  end
end
