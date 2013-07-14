# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  class InvalidationsTest < MiniTest::Unit::TestCase

    def setup
      @cloudfront = Cloudfront.new(AWS_CREDENTIALS[:aws_access_key_id], AWS_CREDENTIALS[:aws_secret_access_key])
    end

    def test_invalidation_send
      VCR.use_cassette('invalidations/send') do
        actual = @cloudfront.invalidation_send("E3NNQMNUOKN8IR", ['/favicon.ico'])
        expected_status = 201
        assert_equal(expected_status, actual.status)
      end
    end

    def test_invalidate_bad_path
      assert_raises(Cloudfront::Exceptions::DistributionConfigurationException) do
        @cloudfront.invalidation_send("E3NNQMNUOKN8IR", ['/favicon.ico', 'index.html'])
      end
    end

    def test_invalidation_list
      VCR.use_cassette('invalidations/list') do
        actual = @cloudfront.invalidation_list("E3NNQMNUOKN8IR")
        expected_status = 200
        assert_equal(expected_status, actual.status)
      end
    end

    def test_get
      VCR.use_cassette('invalidations/get') do
        actual = @cloudfront.invalidation_get("E3NNQMNUOKN8IR", "I9UMIIXC1VYHY")
        expected_status = 200
        assert_equal(expected_status, actual.status)
      end
    end

  end
end
