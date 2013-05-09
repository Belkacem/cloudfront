# encoding: UTF-8

require 'nokogiri'

class Cloudfront
  module Utils
    module XmlSerializer

      def to_xml
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          build_xml(xml)
        end
        builder.to_xml
      end

    end
  end
end
