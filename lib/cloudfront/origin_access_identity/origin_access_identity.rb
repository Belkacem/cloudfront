# encoding: UTF-8

require 'cloudfront/helpers/origin_access_identity'

class Cloudfront
  module OriginAccessIdentity

    URL = "/#{Cloudfront::Utils::Api.version}/origin-access-identity/cloudfront"

    def origin_access_identity_create(origin_access_identity = nil)
      origin_access_identity ||= OriginAccessIdentity.new
      connection.post do |request|
        request.url URL
        request.body = origin_access_identity.to_xml
      end
    end

      def origin_access_identity_list(max_items = 0, marker = "")
        connection.get do |request|
          request.url URL
          request.params['Marker'] = marker unless marker.nil? || marker.blank?
          request.params['MaxItems'] = max_items if max_items > 0
        end
      end

      def origin_access_identity_get(origin_access_identity_id)
        connection.get URL + '/' + origin_access_identity_id
      end

      def origin_access_identity_get_config(origin_access_identity_id)
        connection.get URL + '/' + origin_access_identity_id + '/config'
      end

      def origin_access_identity_put_config(origin_access_identity_id, origin_access_identity, etag)
        connection.put do |request|
          request.url URL + '/' + origin_access_identity_id + '/config'
          request.headers['If-Match'] = etag
          request.body = origin_access_identity.to_xml
        end
      end

      def origin_access_identity_delete(origin_access_identity_id)
        # 1. get the origin_access_identity configuration
        response = origin_access_identity_get_config(origin_access_identity_id)
        etag = response.headers['etag']
        raise Cloudfront::Exceptions::MissingEtagException.new("The etag for the origin_access_identity #{origin_access_identity_id} is missing") if etag.nil? || etag.blank?

        # 2. send a delete request with the returned etag
        connection.delete do |request|
          request.url URL + '/' + origin_access_identity_id
          request.headers['If-Match'] = etag
        end
      end

      def get_origin_access_identity_wrapper(hash)
      end
  end
end


