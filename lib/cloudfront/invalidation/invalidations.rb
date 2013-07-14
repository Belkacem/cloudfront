# encoding: UTF-8

require 'cloudfront/helpers/invalidation'

class Cloudfront
  module Invalidations
    INVALIDATION_URL = "/#{Cloudfront::API_VERSION}/distribution/%s/invalidation"

    # Invalidates files
    # @param distribution_id [String] The id of the distribution.
    # @param files [Array] an array of files to be invalidated.
    # @param caller_reference [String] The custom caller reference to be added to the request.
    # @return [Faraday::Response] the response from cloudfront
    def invalidation_send(distribution_id, files, caller_reference = nil)
      connection.post do |request|
        request.url INVALIDATION_URL % distribution_id
        request.body = invalidation_body(files, caller_reference)
      end
    end

    # Lists all the invalidations.
    # @param distribution_id [String] The id of the distribution.
    # @param max_items [int] the max items to be retrieved
    # @param marker [String] The invalidation from which begins the list.
    # @return [Faraday::Response] the response from cloudfront
    def invalidation_list(distribution_id, max_items = 0, marker = "")
      connection.get do |request|
        request.url INVALIDATION_URL % distribution_id
        request.params['Marker'] = marker unless marker.nil? || marker.strip.empty?
        request.params['MaxItems'] = max_items if max_items > 0
      end
    end

    # gets the invalidation information.
    # @param distribution_id [String] The id of the distribution.
    # @param invalidation_id [String] The id of the invalidation.
    # @return [Faraday::Response] the response from cloudfront
    def invalidation_get(distribution_id, invalidation_id)
      connection.get INVALIDATION_URL % distribution_id + '/' + invalidation_id
    end

    private
    # Method that builds the invalidation body.
    # @param files [Array] an array containing the list of files to be invalidated.
    # @return [String] the xml to be sent to cloudfront.
    def invalidation_body(files, caller_reference)
      invalidation = Invalidation.new ({
          files: files,
          caller_reference: caller_reference
      })
      invalidation.to_xml
    end

  end
end