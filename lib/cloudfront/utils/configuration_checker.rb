class Cloudfront
  module Utils
    module ConfigurationChecker
      attr_reader :error_messages

      def valid?
        (@error_messages ||= []).clear
        validate
        !@error_messages.any?
      end

      def check_configuration
        unless valid?
          raise Cloudfront::Exceptions::DistributionConfigurationException.new "Configuration error : \n #{@error_messages.join "\n"}"
        end
      end
    end
  end
end
