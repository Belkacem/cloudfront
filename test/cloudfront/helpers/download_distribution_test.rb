# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class DownloadDistributionTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        download_distribution = DownloadDistribution.new do
          self.cnames.concat ["test.com", "test2.com"]
          self.default_root_object = "/index.php"
          self.origins.push Origin.new {
            self.id = "test origin"
            self.domain_name = "example.com"
            self.http_port = 90
            self.https_port = 90
          }
          self.origins.push Origin.new {
            self.id = "test origin 2"
            self.domain_name = "example2.com"
            self.origin_access_identity = "origin-access-identity/cloudfront/ID"
          }
          self.default_cache_behavior = CacheBehavior.new {
            self.is_default = true
            self.target_origin_id = "test origin"
            self.query_string_forward = true
          }
          self.cache_behaviors.push CacheBehavior.new {
            self.path_pattern = "*.jpg"
            self.target_origin_id = "test origin"
            self.query_string_forward = true
            self.cookies_forward_policy = "whitelist"
            self.cookies_to_forward = "cookies"
            self.trusted_signers = TrustedSigners.new {
              self.enabled = true
              self.trusted_signers.push "signer"
            }
          }

          self.logging = Logging.new {
            self.enabled = true
            self.bucket = "belkacem.rebbouh.com.s3.amazonaws.com"
            self.prefix = "distribution_test"
          }
          self.price_class = "PriceClass_All"
        end


        xml = download_distribution.to_xml
        xml_from_hash = DownloadDistribution.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

      def test_from_hash
        # this test takes an XML from the cloudfront documentation page
        # converts it to a helper class DownloadDistribution and back to xml
        # then compares it with the source xml
        distribution_xml = '<?xml version="1.0" encoding="UTF-8"?><DistributionConfig xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/"><CallerReference>example.com2012-04-11-5:09pm</CallerReference><Aliases><Quantity>1</Quantity><Items><CNAME>www.example.com</CNAME></Items></Aliases><DefaultRootObject>index.html</DefaultRootObject><Origins><Quantity>2</Quantity><Items><Origin><Id>example-Amazon S3-origin</Id><DomainName>myawsbucket.s3.amazonaws.com</DomainName><S3OriginConfig><OriginAccessIdentity>origin-access-identity/cloudfront/E74FTE3AEXAMPLE</OriginAccessIdentity></S3OriginConfig></Origin><Origin><Id>example-custom-origin</Id><DomainName>example.com</DomainName><CustomOriginConfig><HTTPPort>80</HTTPPort><HTTPSPort>443</HTTPSPort><OriginProtocolPolicy>match-viewer</OriginProtocolPolicy></CustomOriginConfig></Origin></Items></Origins><DefaultCacheBehavior><TargetOriginId>example-Amazon S3-origin</TargetOriginId><ForwardedValues><QueryString>true</QueryString><Cookies><Forward>whitelist</Forward><WhitelistedNames><Quantity>1</Quantity><Items><Name>example-cookie</Name></Items></WhitelistedNames></Cookies></ForwardedValues><TrustedSigners><Enabled>true</Enabled><Quantity>3</Quantity><Items><AwsAccountNumber>self</AwsAccountNumber><AwsAccountNumber>111122223333</AwsAccountNumber><AwsAccountNumber>444455556666</AwsAccountNumber></Items></TrustedSigners><ViewerProtocolPolicy>https-only</ViewerProtocolPolicy><MinTTL>0</MinTTL></DefaultCacheBehavior><CacheBehaviors><Quantity>1</Quantity><Items><CacheBehavior><PathPattern>*.jpg</PathPattern><TargetOriginId>example-custom-origin</TargetOriginId><ForwardedValues><QueryString>false</QueryString><Cookies><Forward>all</Forward></Cookies></ForwardedValues><TrustedSigners><Enabled>true</Enabled><Quantity>2</Quantity><Items><AwsAccountNumber>self</AwsAccountNumber><AwsAccountNumber>111122223333</AwsAccountNumber></Items></TrustedSigners><ViewerProtocolPolicy>allow-all</ViewerProtocolPolicy><MinTTL>86400</MinTTL></CacheBehavior></Items></CacheBehaviors><Comment>example comment</Comment><Logging><Enabled>true</Enabled><IncludeCookies>true</IncludeCookies><Bucket>myawslogbucket.s3.amazonaws.com</Bucket><Prefix>example.com.</Prefix></Logging><PriceClass>PriceClass_All</PriceClass><Enabled>true</Enabled></DistributionConfig>'
        distribution_hash = MultiXml.parse(distribution_xml)
        distribution = DownloadDistribution.from_hash(distribution_hash)
        assert_equal(distribution.to_xml().strip.gsub(/>[\n\ ]+</, "><"), distribution_xml)
      end
    end
  end
end

