# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../helper'))

class CloudfrontTestOld < MiniTest::Unit::TestCase
  
  def setup
    @cloudfront = Cloudfront.new(AWS_CREDENTIALS[:aws_access_key_id],AWS_CREDENTIALS[:aws_secret_access_key])
  end
  
  def test_credentials_test
    VCR.use_cassette('download_distribution/list') do
      assert @cloudfront.credentials_test,"credentials check failed"
    end
  end
end