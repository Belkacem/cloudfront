# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class AliasesTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        aliases = Aliases.new ["test.com", "test2.com"]

        xml = aliases.to_xml
        xml_from_hash = Aliases.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

    end
  end
end

