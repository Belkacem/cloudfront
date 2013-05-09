# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "cloudfront"
  gem.version = '1.1'
  gem.homepage = "https://github.com/Belkacem/cloudfront"
  gem.license = "MIT"
  gem.summary = %Q{A tested Cloudfront™ gem}
  gem.description = %Q{A tested Cloudfront™ client, that handles all api actions on distributions and invalidations}
  gem.email = "belkacem@rebbouh.com"
  gem.authors = ["Belkacem REBBOUH"]
  gem.files = Dir['lib/**/*.rb'] + %w(Gemfile
    LICENSE.txt
    README.rdoc
    Rakefile
    cloudfront.gemspec)
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new
