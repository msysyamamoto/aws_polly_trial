resource "aws_cloudfront_distribution" "distribution_speech_api" {
  origin {
    # see: http://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html
    domain_name = "${aws_api_gateway_rest_api.speech_api.id}.execute-api.${var.region}.amazonaws.com"

    origin_id = "Custom-${aws_api_gateway_rest_api.speech_api.id}.execute-api.${var.region}.amazonaws.com"

    custom_header = {
      name  = "x-api-key"
      value = "${aws_api_gateway_api_key.speech_api_key.value}"
    }

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "match-viewer"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  origin {
    domain_name = "${var.s3_bucket_domain_name}"
    origin_id   = "S3-${var.s3_bucket_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "S3-${var.s3_bucket_name}"

    compress = true

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "Custom-${aws_api_gateway_rest_api.speech_api.id}.execute-api.${var.region}.amazonaws.com"

    path_pattern = "/beta/*"

    forwarded_values {
      query_string            = true
      query_string_cache_keys = ["text", "voice"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  web_acl_id = "${aws_waf_web_acl.waf_acl.id}"
}

resource "aws_cloudfront_origin_access_identity" "access_identity" {
  comment = "access-identity-"
}
