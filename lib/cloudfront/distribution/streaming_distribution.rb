# encoding: UTF-8

require 'cloudfront/helpers/streaming_distribution'
require_relative 'distribution'

class Cloudfront
  module Distribution
    module StreamingDistribution
      include Distribution

      ::STREAMING_DISTRIBUTION_URL = "/#{Cloudfront::Utils::Api.version}/streaming-distribution"

      def streaming_distribution_create(distribution)
        distribution_create(STREAMING_DISTRIBUTION_URL, distribution)
      end

      def streaming_distribution_list(max_items = 0, marker = "")
        distribution_list(STREAMING_DISTRIBUTION_URL, max_items, marker)
      end

      def streaming_distribution_get(distribution_id)
        distribution_get(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

      def streaming_distribution_get_config(distribution_id)
        distribution_get_config(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

      def streaming_distribution_put_config(distribution_id, distribution, etag)
        distribution_put_config(STREAMING_DISTRIBUTION_URL, distribution_id, distribution, etag)
      end

      def streaming_distribution_enable(distribution_id)
        distribution_enable(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

      def streaming_distribution_disable(distribution_id)
        distribution_disable(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

      def streaming_distribution_delete(distribution_id)
        distribution_delete(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

private
      def get_streaming_distribution_wrapper(hash)
        Cloudfront::Helpers::StreamingDistribution.from_hash hash
      end
    end
  end
end


