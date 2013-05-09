# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  class OriginAccessIdentityTest < MiniTest::Unit::TestCase

    include Cloudfront::Connection
    include Cloudfront::OriginAccessIdentity

    attr_accessor :connection

    def setup
      @connection = build_connection(AWS_CREDENTIALS[:aws_access_key_id], AWS_CREDENTIALS[:aws_secret_access_key])

      @sample_origin_access_identity = Helpers::OriginAccessIdentity.new do
        self.caller_reference = "2013-05-08T11:58:37+02:00 737090926"
      end
    end

    def test_origin_access_identity_create
      VCR.use_cassette('origin_access_identity/create') do
        actual = origin_access_identity_create(@sample_origin_access_identity)
        expected_status = 201
        assert_equal(expected_status, actual.status)
      end
    end

    def test_origin_access_identity_list
      VCR.use_cassette('origin_access_identity/list') do
        actual = origin_access_identity_list
        expected_status = 200
        assert_equal(expected_status, actual.status)
      end
    end

    def test_origin_access_identity_get
      VCR.use_cassette('origin_access_identity/get') do
        actual = origin_access_identity_get("E19SYAD0RHLA79")
        expected_status = 200
        assert_equal(expected_status, actual.status)
      end
    end

    def test_origin_access_identity_get_config
      VCR.use_cassette('origin_access_identity/get_config') do
        actual = origin_access_identity_get_config("E19SYAD0RHLA79")
        expected_status = 200
        assert_equal(expected_status, actual.status)
      end
    end

    def test_origin_access_identity_put_config
      VCR.use_cassette('origin_access_identity/put_config') do
        @sample_origin_access_identity.comment = "new comment"
        actual = origin_access_identity_put_config("E19SYAD0RHLA79", @sample_origin_access_identity, "E1PEIV8EG23R37")
        expected_status = 200
        assert_equal(expected_status, actual.status)
      end
    end

    def test_origin_access_identity_delete
      VCR.use_cassette('origin_access_identity/get_config') do
        VCR.use_cassette('origin_access_identity/delete') do
          actual = origin_access_identity_delete("E19SYAD0RHLA79")
          expected_status = 204
          assert_equal(expected_status, actual.status)
        end
      end
    end

  end
end

