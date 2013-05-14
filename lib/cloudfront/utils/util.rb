# encoding: UTF-8

require_relative 'string'
require_relative 'array'

require 'cloudfront/utils/configuration_checker'
require 'cloudfront/utils/xml_serializer'

class Cloudfront
  module Utils
    module Util
      FORWARD_POLICY_VALUES  = %w(all whitelist none)
      VIEWER_PROTOCOL_VALUES = %w(allow-all https-only)
      MATCH_VIEWER_VALUES = %w(http-only match-viewer)
      URL_REGEXP = /(^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
      PRICE_CLASS = %w(PriceClass_100 PriceClass_200 PriceClass_All)
      module_function

      # Generates a random caller reference.
      def generate_caller_reference
        Time.now.xmlschema + ' ' + (0...10).map { ('0'..'9').to_a[rand(10)] }.join
      end

    end
  end
end