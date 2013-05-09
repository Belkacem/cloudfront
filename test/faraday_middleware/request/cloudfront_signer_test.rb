# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class FaradayMiddleware::CloudfrontSignerTest < MiniTest::Unit::TestCase
  def setup
    @signer = FaradayMiddleware::CloudfrontSigner.new(DummyApp.new, "key_id", "key_secret")
  end
  
  def test_build_signature
    time_string = Time.parse('2013-05-08 12:00:00 +0100').httpdate
    actual = @signer.build_signature(time_string)
    expected = "Lux3BOhPWZECsVVNJnH4v9cg+J0="
    assert_equal(expected, actual)
  end
end