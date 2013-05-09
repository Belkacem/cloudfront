# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class OriginsTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        origins = Origins.new do
          self.origins.push Origin.new {
            self.id = "test origin 2"
            self.domain_name = "example2.com"
            self.origin_access_identity = "origin-access-identity/cloudfront/ID"
          }
          self.origins.push Origin.new {
            self.id = "test origin"
            self.domain_name = "example.com"
            self.http_port = 90
            self.https_port = 90
          }
        end


        xml = origins.to_xml
        xml_from_hash = Origins.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

    end
  end
end

