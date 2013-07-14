# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Distribution
    class DownloadDistributionTest < MiniTest::Unit::TestCase

      def setup
        @cloudfront = Cloudfront.new(AWS_CREDENTIALS[:aws_access_key_id],AWS_CREDENTIALS[:aws_secret_access_key])
        @sample_distribution = DownloadDistribution.new do
          self.caller_reference = "2013-05-08T11:58:37+02:00 7379539126"
          self.cnames.concat ["example1.com", "example2.com"]
          self.default_root_object = "index.php"
          self.origins.push Origin.new {
            self.id = "blog"
            self.domain_name = "blog.rebbouh.com"
          }
          self.default_cache_behavior = CacheBehavior.new {
            self.target_origin_id = "blog"
            self.query_string_forward = true
          }
          self.cache_behaviors.push CacheBehavior.new {
            self.path_pattern = "*.jpg"
            self.target_origin_id = "blog"
            self.query_string_forward = false
            self.cookies_forward_policy = "whitelist"
            self.cookies_to_forward = "cookies"
            self.trusted_signers = TrustedSigners.new {
              self.enabled = false
            }
          }
          self.logging = Logging.new {
            self.enabled = true
            self.bucket = "belkacem.rebbouh.com.s3.amazonaws.com"
            self.prefix = "test_distribution"
          }
        end
      end

      def test_download_distribution_create
        VCR.use_cassette('download_distribution/create') do
          actual = @cloudfront.download_distribution_create(@sample_distribution)
          expected_status = 201
          assert_equal(expected_status, actual.status)
        end
      end

      def test_download_distribution_list
        VCR.use_cassette('download_distribution/list') do
          actual = @cloudfront.download_distribution_list
          expected_status = 200
          assert_equal(expected_status, actual.status)
        end
      end

      def test_download_distribution_get
        VCR.use_cassette('download_distribution/get') do
          actual = @cloudfront.download_distribution_get("E30FYUOU1WV09Z")
          expected_status = 200
          assert_equal(expected_status, actual.status)
        end
      end

      def test_download_distribution_get_config
        VCR.use_cassette('download_distribution/get_config_disabled') do
          actual = @cloudfront.download_distribution_get_config("E30FYUOU1WV09Z")
          expected_status = 200
          assert_equal(expected_status, actual.status)
        end
      end

      def test_download_distribution_put_config
        VCR.use_cassette('download_distribution/put_config_disabled') do
          actual = @cloudfront.download_distribution_put_config("E30FYUOU1WV09Z", @sample_distribution, "E1MFMJQXOWT9WE")
          expected_status = 200
          assert_equal(expected_status, actual.status)
        end
      end

      def test_download_distribution_enable
        VCR.use_cassette('download_distribution/get_config_disabled') do
          VCR.use_cassette('download_distribution/put_config_enabled') do
            actual = @cloudfront.download_distribution_enable("E30FYUOU1WV09Z")
            expected_status = 200
            assert_equal(expected_status, actual.status)
          end
        end
      end

      def test_download_distribution_disable
        VCR.use_cassette('download_distribution/get_config_enabled') do
          VCR.use_cassette('download_distribution/put_config_disabled') do
            actual = @cloudfront.download_distribution_disable("E30FYUOU1WV09Z")
            expected_status = 200
            assert_equal(expected_status, actual.status)
          end
        end
      end

      def test_download_distribution_delete
        VCR.use_cassette('download_distribution/delete') do
          actual = @cloudfront.download_distribution_delete("E30FYUOU1WV09Z")
          expected_status = 204
          assert_equal(expected_status, actual.status)
        end
      end

    end
  end
end

