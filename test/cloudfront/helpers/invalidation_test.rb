# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class InvalidationTest < MiniTest::Unit::TestCase
      def test_serialize_deserialize
        invalidation = Invalidation.new ({
            files: ["/test.txt", "/test2.txt"]
        })

        xml = invalidation.to_xml
        xml_from_hash = Invalidation.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

      def test_from_hash
        # this test takes an XML from the cloudfront documentation page
        # converts it to a helper class Invalidation and back to xml
        # then compares it with the source xml
        invalidation_xml = '<?xml version="1.0" encoding="UTF-8"?><InvalidationBatch xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/"><Paths><Quantity>1</Quantity><Items><Path>/path to object to invalidate</Path></Items></Paths><CallerReference>unique identifier for this invalidation batch</CallerReference></InvalidationBatch>'
        invalidation_hash = MultiXml.parse(invalidation_xml)
        invalidation = Invalidation.from_hash(invalidation_hash)
        assert_equal(invalidation.to_xml().strip.gsub(/>[\n\ ]+</, "><"), invalidation_xml)
      end

    end
  end
end

