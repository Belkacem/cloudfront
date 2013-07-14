# encoding: UTF-8

require 'cloudfront/helpers/download_distribution'
require_relative 'distribution'

class Cloudfront
  module Distribution
    module DownloadDistributionActions
      include Distribution

      DOWNLOAD_DISTRIBUTION_URL = "/#{Cloudfront::API_VERSION}/distribution"

      # Creates a download distribution.
      # @param distribution [Cloudfront::Helpers::DownloadDistribution] a distribution configuration wrapper
      # @return [Faraday::Response] the response from cloudfront
      def download_distribution_create(distribution)
        distribution_create(DOWNLOAD_DISTRIBUTION_URL, distribution)
      end

      # Lists all the download distributions.
      # @param max_items [int] the max items to be retrieved
      # @param marker [String] The distribution id from which begins the list.
      # @return [Faraday::Response] the response from cloudfront
      def download_distribution_list(max_items = 0, marker = "")
        distribution_list(DOWNLOAD_DISTRIBUTION_URL, max_items, marker)
      end

      # Gets the download distribution information.
      # @param distribution_id [String] The id of the distribution to be returned.
      # @return [Faraday::Response] the response from cloudfront
      def download_distribution_get(distribution_id)
        distribution_get(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

      # Returns the download distribution configuration.
      # @param distribution_id [String] The id of the distribution to be returned.
      # @return [Faraday::Response] the response from cloudfront
      def download_distribution_get_config(distribution_id)
        distribution_get_config(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

      # Puts the download distribution configuration.
      # To put a distribution config we must follow a certain process defined in
      # http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HowToUpdateDistribution.html
      # @param distribution_id [String] The id of the distribution.
      # @param distribution [Cloudfront::Helpers::Distribution] a distribution configuration wrapper
      # @param etag [String] The etag.
      # @return [Faraday::Response] the response from cloudfront
      def download_distribution_put_config(distribution_id, distribution, etag)
        distribution_put_config(DOWNLOAD_DISTRIBUTION_URL, distribution_id, distribution, etag)
      end

      # Enables a download distribution.
      # @param distribution_id [String] The id of the distribution to be enabled.
      # @return [Faraday::Response] the response from cloudfront
      def download_distribution_enable(distribution_id)
        distribution_enable(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

      # Disables a download distribution.
      # @param distribution_id [String] The id of the distribution to be disabled.
      # @return [Faraday::Response] the response from cloudfront
      def download_distribution_disable(distribution_id)
        distribution_disable(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

      # Deletes a download distribution.
      # @param distribution_id [String] The id of the distribution to be deleted.
      # @return [Faraday::Response] the response from cloudfront
      def download_distribution_delete(distribution_id)
        distribution_delete(DOWNLOAD_DISTRIBUTION_URL, distribution_id)
      end

private
      def get_download_distribution_wrapper(hash)
        DownloadDistribution.from_hash hash
      end

    end
  end
end


