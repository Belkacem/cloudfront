# encoding: UTF-8

require 'faraday'
require 'faraday_middleware/response/parse_xml'
require 'faraday_middleware/request/cloudfront_signer'
require 'faraday_middleware/request/xml_content_type.rb'

class Cloudfront
  module Connection
    HOST = 'https://cloudfront.amazonaws.com'
    
    def build_connection(key_id, key_secret)
      Faraday::Connection.new(HOST) do |builder|
        builder.use FaradayMiddleware::CloudfrontSigner, key_id, key_secret
        builder.use FaradayMiddleware::XmlContentType
        builder.use FaradayMiddleware::ParseXml

        # Used for debug purpose only.
        # builder.use Faraday::Response::Logger
        
        builder.use Faraday::Adapter::NetHttp
      end
    end
  end
end
