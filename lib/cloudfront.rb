# encoding: UTF-8

require 'cloudfront/utils/util'

require 'cloudfront/connection'
require 'cloudfront/version'

require 'cloudfront/distribution/download_distribution'
require 'cloudfront/distribution/streaming_distribution'

require 'cloudfront/invalidation/invalidations'
require 'cloudfront/origin_access_identity/origin_access_identity'

# Errors and exceptions
require 'cloudfront/exceptions/distribution_configuration_exception'

class Cloudfront
  include Cloudfront::Connection
  include Cloudfront::Distribution::DownloadDistribution
  include Cloudfront::Distribution::StreamingDistribution
  include Cloudfront::Invalidation::Invalidations
  include Cloudfront::OriginAccessIdentity

  # @attr_reader [Faraday::Connection] connection accession to the connection established with cloudfront.
  attr_accessor :connection
  def initialize(key_id, key_secret)
    @connection = build_connection(key_id, key_secret)
  end
  
  def credentials_test
    download_distribution_list.status == 200
  end
end

# For easier handling of helpers
include Cloudfront::Helpers

