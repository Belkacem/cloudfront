# encoding: UTF-8

require_relative 'trusted_signers'

class Cloudfront
  module Helpers
    class CacheBehavior
      include Cloudfront::Utils::ConfigurationChecker
      include Cloudfront::Utils::XmlSerializer

      attr_accessor :is_default,
                    :path_pattern,
                    :target_origin_id,
                    :query_string_forward,
                    :cookies_forward_policy,
                    :cookies_to_forward,
                    :trusted_signers,
                    :viewer_protocol_policy,
                    :min_ttl

      def initialize(params = {}, &block)
        #set default values
        @is_default = false
        @path_pattern = params[:path_pattern]
        @target_origin_id = params[:target_origin_id]
        @query_string_forward = params[:query_string_forward] || true
        @cookies_forward_policy = params[:cookies_forward_policy] || "all"
        @cookies_to_forward = params[:cookies_to_forward]
        @trusted_signers = params[:trusted_signers] || TrustedSigners.new
        @viewer_protocol_policy = params[:viewer_protocol_policy] || "allow-all"
        @min_ttl = params[:min_ttl] || 86400 # one day as the default minimum ttl

        #set values from block
        instance_eval &block if block_given?
      end

      def validate
        # some wrapping
        @cookies_to_forward = Array.wrap @cookies_to_forward

        # Error checking
        error_messages.push "target_origin_id shouldn't be nil" if @target_origin_id.nil?
        error_messages.push "query_string_forward must be a boolean" unless !!@query_string_forward == @query_string_forward
        error_messages.push "cookies_forward_policy should be one of #{Cloudfront::Utils::Util::FORWARD_POLICY_VALUES.join(', ')}" unless Cloudfront::Utils::Util::FORWARD_POLICY_VALUES.include?(@cookies_forward_policy)
        # trusted signers validation
        if @trusted_signers.is_a?(TrustedSigners)
          @trusted_signers.check_configuration
        else
          error_messages.push "trusted_signer field should be a TrustedSigners"
        end

        error_messages.push "viewer_protocol_policy should be one of #{Cloudfront::Utils::Util::VIEWER_PROTOCOL_VALUES.join(', ')}" unless Cloudfront::Utils::Util::VIEWER_PROTOCOL_VALUES.include?(@viewer_protocol_policy)
        error_messages.push "min_ttl should be a number" unless @min_ttl.is_a? Fixnum
      end

      def cache_behavior_body(xml)
        unless @is_default
          xml.PathPattern @path_pattern
        end
        xml.TargetOriginId @target_origin_id
        xml.ForwardedValues {
          xml.QueryString @query_string_forward
          xml.Cookies {
            xml.Forward @cookies_forward_policy
            if (@cookies_forward_policy == "whitelist")
              xml.WhitelistedNames {
                xml.Quantity @cookies_to_forward.size
                if (@cookies_to_forward.size > 0)
                  xml.Items {
                    for cookie in @cookies_to_forward
                      xml.Name cookie
                    end
                  }
                end
              }
            end
          }
        }
        @trusted_signers.build_xml(xml)
        xml.ViewerProtocolPolicy @viewer_protocol_policy
        xml.MinTTL @min_ttl
      end

      # Creates a CacheBehavior instance from a hash
      #  {
      #    "CacheBehavior" => {
      #        "PathPattern"     => "*",
      #        "TargetOriginId"  => "id",
      #        "ForwardedValues" => {
      #            "QueryString"   => "true",
      #            "Cookies"       => {
      #                "Forward"          => "all | whitelist | none",
      #                "WhitelistedNames" => {
      #                    "Quantity"       => "0",
      #                    "Items"          =>
      #                        {
      #                            "Name"    => ["name of a cookie to forward to the origin"]
      #                        }
      #                }
      #            }
      #        },
      #        "TrustedSigners"       => {},
      #        "ViewerProtocolPolicy" => "allow-all",
      #        "MinTTL"                => "86400"
      #    }
      #  }
      def self.from_hash(hash)
        hash = hash["DefaultCacheBehavior"] || hash["CacheBehavior"] || hash
        self.new do
          self.is_default = !hash.has_key?("PathPattern")
          self.path_pattern = hash["PathPattern"]
          self.target_origin_id = hash["TargetOriginId"]
          forwarded_values = hash["ForwardedValues"]
          if forwarded_values
            self.query_string_forward = (forwarded_values["QueryString"] || "true").to_bool
            cookies = forwarded_values["Cookies"]
            if cookies
              self.cookies_forward_policy = cookies["Forward"] || "all"
              white_listed_names = cookies["WhitelistedNames"]
              if (white_listed_names && white_listed_names["Items"]||{})["Name"]
                self.cookies_to_forward = Array.wrap white_listed_names["Items"]["Name"]
              end
            end
          end
          self.trusted_signers = TrustedSigners.from_hash(hash["TrustedSigners"])
          self.viewer_protocol_policy = hash["ViewerProtocolPolicy"] || "allow-all"
          self.min_ttl = (hash["MinTTL"] || "86400").to_i
        end
      end

      # The cache behavior class container
      #      <CacheBehavior>
      #        <PathPattern>pattern that specifies files that this cache behavior applies to</PathPattern>
      #        <TargetOriginId>ID of the origin that this cache behavior applies to</TargetOriginId>
      #        <ForwardedValues>
      #          <QueryString>true | false</QueryString>
      #          <Cookies>
      #            <Forward>all | whitelist | none</Forward>
      #            <!-- Required when Forward = whitelist, omitted otherwise. -->
      #            <WhitelistedNames>
      #              <Quantity>number of cookie names to forward to origin</Quantity>
      #              <Items>
      #                <Name>name of a cookie to forward to the origin</Name>
      #              </Items>
      #            </WhitelistedNames>
      #          </Cookies>
      #        </ForwardedValues>
      #        <TrustedSigners>
      #          ... see TrustedSigners class
      #        </TrustedSigners>
      #        <ViewerProtocolPolicy>allow-all | https-only</ViewerProtocolPolicy>
      #        <MinTTL>minimum TTL in seconds for files specified by PathPattern</MinTTL>
      #      </CacheBehavior>
      def build_xml(xml)
        check_configuration
        if @is_default
          xml.DefaultCacheBehavior {
            cache_behavior_body(xml)
          }
        else
          xml.CacheBehavior {
            cache_behavior_body(xml)
          }
        end
      end

    end
  end
end
