# encoding: UTF-8

require 'cloudfront/helpers/download_distribution'
require_relative 'distribution'

class Cloudfront
  module Distribution
    module DownloadDistribution
      include Distribution

      ::DOWNLOAD_DISTRIBUTION_URL = "/#{Cloudfront::Utils::Api.version}/distribution"

      def download_distribution_create(distribution)
        distribution_create(DOWNLOAD_DISTRIBUTION_URL, distribution)
      end

      def download_distribution_list(max_items = 0, marker = "")
        distribution_list(DOWNLOAD_DISTRIBUTION_URL, max_items, marker)
      end

      def download_distribution_get(distribution_id)
        distribution_get(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

      def download_distribution_get_config(distribution_id)
        distribution_get_config(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

      def download_distribution_put_config(distribution_id, distribution, etag)
        distribution_put_config(DOWNLOAD_DISTRIBUTION_URL, distribution_id, distribution, etag)
      end

      def download_distribution_enable(distribution_id)
        distribution_enable(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

      def download_distribution_disable(distribution_id)
        distribution_disable(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

      def download_distribution_delete(distribution_id)
        distribution_delete(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

private
      def get_download_distribution_wrapper(hash)
        Cloudfront::Helpers::DownloadDistribution.from_hash hash
      end

    end
  end
end


