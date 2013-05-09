# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '../../helper'))

class Cloudfront
  module Helpers
    class StreamingDistributionTest < MiniTest::Unit::TestCase

      def test_serialize_deserialize
        streaming_distribution = StreamingDistribution.new do
          self.domain_name = "belkacem.rebbouh.com.s3.amazonaws.com"
          self.origin_access_identity = "origin-access-identity/cloudfront/ID"
          self.cnames.concat ["test.com", "test2.com"]
          self.logging = Logging.new {
            self.enabled = true
            self.bucket = "belkacem.rebbouh.com.s3.amazonaws.com"
            self.prefix = "distribution_test"
          }
          self.trusted_signers.push "signer"
          self.price_class = "PriceClass_All"
        end

        xml = streaming_distribution.to_xml
        xml_from_hash = StreamingDistribution.from_hash(MultiXml.parse(xml)).to_xml
        assert_equal(xml_from_hash.strip, xml.strip)
      end

      def test_from_hash
        # this test takes an XML from the cloudfront documentation page
        # converts it to a helper class StreamingDistribution and back to xml
        # then compares it with the source xml
        streaming_distribution_xml = '<?xml version="1.0" encoding="UTF-8"?><StreamingDistributionConfig xmlns="http://cloudfront.amazonaws.com/doc/2012-07-01/"><CallerReference>unique description for this distribution</CallerReference><S3Origin><DomainName>CloudFront domain name assigned to the distribution</DomainName><OriginAccessIdentity>origin-access-identity/cloudfront/ID</OriginAccessIdentity></S3Origin><Aliases><Quantity>1</Quantity><Items><CNAME>CNAME.com</CNAME></Items></Aliases><Comment>comment about the distribution</Comment><Logging><Enabled>true</Enabled><Bucket>Amazon S3 bucket for logs</Bucket><Prefix>prefix for log file names</Prefix></Logging><TrustedSigners><Enabled>true</Enabled><Quantity>1</Quantity><Items><AwsAccountNumber>self</AwsAccountNumber></Items></TrustedSigners><PriceClass>PriceClass_100</PriceClass><Enabled>false</Enabled></StreamingDistributionConfig>'
        streaming_distribution_hash = MultiXml.parse(streaming_distribution_xml)
        streaming_distribution = StreamingDistribution.from_hash(streaming_distribution_hash)
        assert_equal(streaming_distribution.to_xml().strip.gsub(/>[\n\ ]+</, "><"), streaming_distribution_xml)
      end
    end
  end
end

