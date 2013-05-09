# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class LoggingTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        logging = Logging.new {
          self.enabled = true
          self.bucket = "belkacem.rebbouh.com.s3.amazonaws.com"
          self.prefix = "distribution_test"
        }


        xml = logging.to_xml
        xml_from_hash = Logging.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

    end
  end
end

