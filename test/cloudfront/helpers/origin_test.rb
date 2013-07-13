# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class OriginTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        origin = Origin.new ({
          id: "test origin",
          domain_name: "example.com",
          http_port:  90,
          https_port: 90
        })

        xml = origin.to_xml
        xml_from_hash = Origin.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)

        origin2 = Origin.new {
          self.id = "test origin 2"
          self.domain_name = "example2.com"
          self.origin_access_identity = "origin-access-identity/cloudfront/ID"
        }


        xml2 = origin2.to_xml
        xml_from_hash2 = Origin.from_hash(MultiXml.parse(xml2)).to_xml
        assert_equal(xml_from_hash2.strip, xml2.strip)
      end

    end
  end
end

