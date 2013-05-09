# encoding: UTF-8

class Cloudfront
  module Helpers
    class Logging 
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :enabled,
                    :include_cookies,
                    :bucket,
                    :prefix

      def initialize(&block)
        #set default values
        @enabled = false
        @include_cookies = false
        #set values from block
        instance_eval &block if block_given?
      end

      def validate
        error_messages.push "enabled should be a boolean" unless !!@enabled == @enabled
        error_messages.push "include_cookies should be a boolean or 'undefined'" unless !!@include_cookies == @include_cookies || @include_cookies == "undefined"
        error_messages.push "You must specify a bucket" if @enabled && @bucket.nil?
      end

      # A factory method that creates a Logging instance from a hash
      # Input example
      # hash = {
      #     "Logging" => {
      #         "Enabled" => "true | false",
      #         "IncludeCookies" => "true | false",
      #         "Bucket" => "Amazon S3 bucket to save logs in",
      #         "Prefix" => "prefix for log filenames"
      #     }
      # }
      def self.from_hash(hash)
        hash = hash["Logging"] || hash
        self.new do
          self.enabled = (hash["Enabled"] || "false").to_bool
          self.include_cookies = hash["IncludeCookies"].nil? ? "undefined" : hash["IncludeCookies"].to_bool
          if self.enabled
            self.bucket = hash["Bucket"]
            self.prefix = hash["Prefix"]
          end
        end
      end

      # build the xml
      #  <Logging>
      #    <Enabled>true | false</Enabled>
      #    <IncludeCookies>true | false</IncludeCookies>
      #    <Bucket>Amazon S3 bucket to save logs in</Bucket>
      #    <Prefix>prefix for log filenames</Prefix>
      #  </Logging>
      def build_xml(xml)
        check_configuration
        xml.Logging {
          xml.Enabled @enabled
          xml.IncludeCookies @include_cookies unless @include_cookies == "undefined"
          if @enabled
            xml.Bucket @bucket
            xml.Prefix @prefix
          end
        }
      end
      
    end
  end
end
