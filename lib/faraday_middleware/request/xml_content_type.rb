# encoding: UTF-8

module FaradayMiddleware
  class XmlContentType < Faraday::Middleware

    CONTENT_TYPE = 'Content-Type'
    TEXT_XML = 'text/xml'

    def initialize(app, *args)
      @app = app
    end

    def call(env)
      if [:post, :put].include? env[:method]
        env[:request_headers].merge!(CONTENT_TYPE => TEXT_XML)
      end
      @app.call env
    end
  end
end
