# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class DownloadDistributionTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        trusted_signers = TrustedSigners.new {
          self.trusted_signers.push "signer"
        }

        xml = trusted_signers.to_xml
        xml_from_hash = TrustedSigners.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

    end
  end
end

