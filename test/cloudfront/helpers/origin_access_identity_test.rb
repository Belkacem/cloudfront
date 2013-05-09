# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class OriginAccessIdentityTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        origin_access_identity = OriginAccessIdentity.new

        xml = origin_access_identity.to_xml
        xml_from_hash = OriginAccessIdentity.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

      def test_from_hash
        # this test takes an XML from the cloudfront documentation page
        # converts it to a helper class OriginAccessIdentity and back to xml
        # then compares it with the source xml
        origin_access_identity_xml = '<?xml version="1.0" encoding="UTF-8"?><CloudFrontOriginAccessIdentityConfig xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/"><CallerReference>ref</CallerReference><Comment>The comment.</Comment></CloudFrontOriginAccessIdentityConfig>'
        origin_access_identity_hash = MultiXml.parse(origin_access_identity_xml)
        origin_access_identity = OriginAccessIdentity.from_hash(origin_access_identity_hash)
        assert_equal(origin_access_identity.to_xml().strip.gsub(/>[\n\ ]+</, "><"), origin_access_identity_xml)
      end
    end
  end
end

