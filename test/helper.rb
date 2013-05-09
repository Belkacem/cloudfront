# encoding: UTF-8

require 'rubygems'
require 'bundler'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/unit'
require 'minitest/pride'
require 'vcr'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'cloudfront'
require 'dummy_app'

VCR.config do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), 'fixtures/vcr_cassettes')
  c.stub_with :webmock
end

class MiniTest::Unit::TestCase
end

MiniTest::Unit.autorun

require 'yaml'
yml = File.join(File.expand_path(File.dirname(__FILE__)), 'aws_credentials.yml')
if (File.exists? yml)
  AWS_CREDENTIALS = YAML.load(File.open(yml))
else
  AWS_CREDENTIALS = { aws_access_key_id: "key_id", aws_secret_access_key: "secret_key"}
end
