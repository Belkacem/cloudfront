# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Distribution
    class StreamingDistributionTest < MiniTest::Unit::TestCase

      def setup
        @cloudfront = Cloudfront.new(AWS_CREDENTIALS[:aws_access_key_id],AWS_CREDENTIALS[:aws_secret_access_key])
        @sample_distribution = StreamingDistribution.new do
          self.domain_name = "belkacem.rebbouh.com.s3.amazonaws.com"
          self.origin_access_identity = "origin-access-identity/cloudfront/E1WAPXK5AQJ6A9"
          self.cnames.concat ["belkacem.rebbouh.com", "belka.rebbouh.com"]
          self.logging = Logging.new {
            self.enabled = true
            self.bucket = "belkacem.rebbouh.com.s3.amazonaws.com"
            self.prefix = "distribution_test"
          }
          self.trusted_signers.push "self"
          self.price_class = "PriceClass_All"
        end
      end

      def test_streaming_distribution_create
        VCR.use_cassette('streaming_distribution/create') do
          actual = @cloudfront.streaming_distribution_create(@sample_distribution)
          expected_status = 201
          assert_equal(expected_status, actual.status)
        end
      end

      def test_streaming_distribution_list
        VCR.use_cassette('streaming_distribution/list') do
          actual = @cloudfront.streaming_distribution_list
          expected_status = 200
          assert_equal(expected_status, actual.status)
        end
      end

      def test_streaming_distribution_get
        VCR.use_cassette('streaming_distribution/get') do
          actual = @cloudfront.streaming_distribution_get("ECO1BY8RW36Z9")
          expected_status = 200
          assert_equal(expected_status, actual.status)
        end
      end

      def test_streaming_distribution_get_config
        VCR.use_cassette('streaming_distribution/get_config_disabled') do
          actual = @cloudfront.streaming_distribution_get_config("ECO1BY8RW36Z9")
          expected_status = 200
          assert_equal(expected_status, actual.status)
        end
      end

      def test_streaming_distribution_enable
        VCR.use_cassette('streaming_distribution/get_config_disabled') do
          VCR.use_cassette('streaming_distribution/put_config_enabled') do
            actual = @cloudfront.streaming_distribution_enable("ECO1BY8RW36Z9")
            expected_status = 200
            assert_equal(expected_status, actual.status)
          end
        end
      end

      def test_streaming_distribution_disable
        VCR.use_cassette('streaming_distribution/get_config_enabled') do
          VCR.use_cassette('streaming_distribution/put_config_disabled') do
            actual = @cloudfront.streaming_distribution_disable("ECO1BY8RW36Z9")
            expected_status = 200
            assert_equal(expected_status, actual.status)
          end
        end
      end

      def test_streaming_distribution_delete
        VCR.use_cassette('streaming_distribution/delete') do
          actual = @cloudfront.streaming_distribution_delete("ECO1BY8RW36Z9")
          expected_status = 204
          assert_equal(expected_status, actual.status)
        end
      end

    end
  end
end

