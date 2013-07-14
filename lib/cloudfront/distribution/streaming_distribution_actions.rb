# encoding: UTF-8

require 'cloudfront/helpers/streaming_distribution'
require_relative 'distribution'

class Cloudfront
  module Distribution
    module StreamingDistributionActions
      include Distribution

      STREAMING_DISTRIBUTION_URL = "/#{Cloudfront::API_VERSION}/streaming-distribution"

      # Creates a streaming distribution.
      # @param distribution [Cloudfront::Helpers::DownloadDistribution] a distribution configuration wrapper
      # @return [Faraday::Response] the response from cloudfront
      def streaming_distribution_create(distribution)
        distribution_create(STREAMING_DISTRIBUTION_URL, distribution)
      end

      # Lists all the streaming distributions.
      # @param max_items [int] the max items to be retrieved
      # @param marker [String] The distribution id from which begins the list.
      # @return [Faraday::Response] the response from cloudfront
      def streaming_distribution_list(max_items = 0, marker = "")
        distribution_list(STREAMING_DISTRIBUTION_URL, max_items, marker)
      end

      # Gets the streaming distribution information.
      # @param distribution_id [String] The id of the distribution to be returned.
      # @return [Faraday::Response] the response from cloudfront
      def streaming_distribution_get(distribution_id)
        distribution_get(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

      # Returns the streaming distribution configuration.
      # @param distribution_id [String] The id of the distribution to be returned.
      # @return [Faraday::Response] the response from cloudfront
      def streaming_distribution_get_config(distribution_id)
        distribution_get_config(STREAMING_DISTRIBUTION_URL, distribution_id)
      end


      # Puts the streaming distribution configuration.
      # To put a distribution config we must follow a certain process defined in
      # http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HowToUpdateDistribution.html
      # @param distribution_id [String] The id of the distribution.
      # @param distribution [Cloudfront::Helpers::Distribution] a distribution configuration wrapper
      # @param etag [String] The etag.
      # @return [Faraday::Response] the response from cloudfront
      def streaming_distribution_put_config(distribution_id, distribution, etag)
        distribution_put_config(STREAMING_DISTRIBUTION_URL, distribution_id, distribution, etag)
      end

      # Enables a streaming distribution.
      # @param distribution_id [String] The id of the distribution to be enabled.
      # @return [Faraday::Response] the response from cloudfront
      def streaming_distribution_enable(distribution_id)
        distribution_enable(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

      # Disables a streaming distribution.
      # @param distribution_id [String] The id of the distribution to be disabled.
      # @return [Faraday::Response] the response from cloudfront
      def streaming_distribution_disable(distribution_id)
        distribution_disable(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

      # Deletes a streaming distribution.
      # @param distribution_id [String] The id of the distribution to be deleted.
      # @return [Faraday::Response] the response from cloudfront
      def streaming_distribution_delete(distribution_id)
        distribution_delete(STREAMING_DISTRIBUTION_URL, distribution_id)
      end

private
      def get_streaming_distribution_wrapper(hash)
        StreamingDistribution.from_hash hash
      end
    end
  end
end


