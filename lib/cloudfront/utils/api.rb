# encoding: UTF-8

require 'cloudfront/utils/string'
require 'cloudfront/utils/array'

class Cloudfront
  module Utils
    module Api
      API = '2012-07-01'
      module_function

      # Returns the API version.
      def version
        API
      end
    end
  end
end