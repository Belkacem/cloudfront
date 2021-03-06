# encoding: UTF-8

class Cloudfront
  module Distribution
    module Distribution
      private
      def distribution_create(url, distribution)
        connection.post do |request|
          request.url url
          request.body = distribution.to_xml
        end
      end

      def distribution_list(url, max_items = 0, marker = "")
        connection.get do |request|
          request.url url
          request.params['Marker'] = marker unless marker.nil? || marker.blank?
          request.params['MaxItems'] = max_items if max_items > 0
        end
      end

      def distribution_get(url, distribution_id)
        connection.get url + '/' + distribution_id
      end

      def distribution_get_config(url, distribution_id)
        connection.get url + '/' + distribution_id + '/config'
      end

      def distribution_put_config(url, distribution_id, distribution, etag)
        connection.put do |request|
          request.url url + '/' + distribution_id + '/config'
          request.headers['If-Match'] = etag
          request.body = distribution.to_xml
        end
      end

      def distribution_enable(url, distribution_id)
        # 1. get the distribution configuration
        response = distribution_get_config(url, distribution_id)
        etag = response.headers['etag']
        raise Cloudfront::Exceptions::MissingEtagException.new("The etag for the distribution #{distribution_id} is missing") if etag.nil? || etag.blank?

        distribution = get_distribution_wrapper(url, response.body)
        raise Cloudfront::Exceptions::DistributionAlreadyEnabledException.new("The distribution #{distribution_id} is already enabled!") if distribution.enabled

        # 2. change the Enabled state
        distribution.enabled = true

        # 3. send a put configuration request with the returned etag
        distribution_put_config(url, distribution_id, distribution, etag)
      end

      def distribution_disable(url, distribution_id)
        # 1. get the distribution configuration
        response = distribution_get_config(url, distribution_id)
        etag = response.headers['etag']
        raise Cloudfront::Exceptions::MissingEtagException.new("The etag for the distribution #{distribution_id} is missing") if etag.nil? || etag.blank?

        distribution = get_distribution_wrapper(url, response.body)
        raise Cloudfront::Exceptions::DistributionAlreadyDisabledException.new("The distribution #{distribution_id} is already disabled") unless distribution.enabled

        # 2. change the enabled to false
        distribution.enabled = false
        # 2. send a put configuration request with the returned etag
        distribution_put_config(url, distribution_id, distribution, etag)
      end

      def distribution_delete(url, distribution_id)
        # 1. get the distribution configuration
        response = distribution_get_config(url, distribution_id)
        etag = response.headers['etag']
        raise Cloudfront::Exceptions::MissingEtagException.new("The etag for the distribution #{distribution_id} is missing") if etag.nil? || etag.blank?

        distribution = get_distribution_wrapper(url, response.body)
        raise Cloudfront::Exceptions::DeleteEnabledDistributionException.new("The distribution #{distribution_id} can't be deleted, disabled it first!") if distribution.enabled

        # 2. send a delete request with the returned etag
        connection.delete do |request|
          request.url url + '/' + distribution_id
          request.headers['If-Match'] = etag
        end
      end

      def get_distribution_wrapper(url, hash)
        if (url.include? "streaming")
          get_streaming_distribution_wrapper(hash)
        else
          get_download_distribution_wrapper(hash)
        end
      end

    end
  end
end


