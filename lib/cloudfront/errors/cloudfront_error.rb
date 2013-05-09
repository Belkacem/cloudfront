# encoding: UTF-8

class Cloudfront
  module Errors
    class CloudfrontError < StandardError
      attr_reader :response
      def initialize(message, response = nil)
        super(message)
        @response = response
      end
    end
  end
end
