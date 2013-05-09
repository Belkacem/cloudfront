# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Faraday::Request::CloudfrontSignerTest < MiniTest::Unit::TestCase
  def setup
    @signer = FaradayMiddleware::CloudfrontSigner.new(DummyApp.new, "key_id", "key_secret")
  end
  
  def test_build_signature
    time_string = Time.parse('2012-01-03 15:56:05 +0100').httpdate
    actual = @signer.build_signature(time_string)
    expected = "HfyPn/Hu+tjCJ8kBvbjngYnxIyU="
    assert_equal(expected, actual)
  end
end