# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class CacheBehaviorTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        cache_behaviors = CacheBehaviors.new do
          self.cache_behaviors.push CacheBehavior.new {
            self.path_pattern = "*.jpg"
            self.target_origin_id = "test origin"
            self.query_string_forward = true
            self.cookies_forward_policy = "whitelist"
            self.cookies_to_forward = "cookies"
            self.trusted_signers = TrustedSigners.new {
              self.enabled = true
              self.trusted_signers.push "signer"
            }
          }
        end

        xml = cache_behaviors.to_xml
        xml_from_hash = CacheBehaviors.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

    end
  end
end

