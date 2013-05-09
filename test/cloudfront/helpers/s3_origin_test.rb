# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class S3OriginTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        origin = S3Origin.new {
          self.domain_name = "example.com"
          self.origin_access_identity = "origin-access-identity/cloudfront/ID"
        }


        xml = origin.to_xml
        xml_from_hash = S3Origin.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

    end
  end
end

