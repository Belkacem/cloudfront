# encoding: UTF-8

require 'time'
require 'openssl'

module FaradayMiddleware
  class CloudfrontSigner < Faraday::Middleware
    ALGORITHM = 'sha1'
    CODE = 'm'
    AUTHORIZATION = 'Authorization'
    DATE = 'Date'
    AWS = 'AWS'
    SPACE = ' '
    COLON = ':'
    def initialize(app, *args)
      @app = app
      @aws_access_key_id = args.shift
      @aws_secret_access_key = args.shift
    end

    # Method that builds the signature to the request.
    # @param date_string [String] the string representation of date time.
    # @return [String] the signature.
    def build_signature(date_string)
      digest = OpenSSL::Digest::Digest.new(ALGORITHM)
      [OpenSSL::HMAC.digest(digest, @aws_secret_access_key, date_string)].pack(CODE).strip
    end
    
    def call(env)
      date = Time.now.httpdate
      env[:request_headers].merge!(AUTHORIZATION => "#{AWS}#{SPACE}#{@aws_access_key_id}#{COLON}#{build_signature(date)}", DATE => date)
      @app.call env
    end
  end
end