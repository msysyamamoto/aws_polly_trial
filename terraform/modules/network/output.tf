output "source_arn_speech_get" {
  value = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.speech_api.id}/*/${aws_api_gateway_integration.integration_speech_get.http_method}${aws_api_gateway_resource.resource_speech.path}"
}

output "source_arn_voices_get" {
  value = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.speech_api.id}/*/${aws_api_gateway_integration.integration_voices_get.http_method}${aws_api_gateway_resource.resource_voices.path}"
}

output "api_key" {
  value = "${aws_api_gateway_api_key.speech_api_key.value}"
}

output "access_identity_iam_arn" {
  value = "${aws_cloudfront_origin_access_identity.access_identity.iam_arn}"
}

output "cloudfront_domain_name" {
  value = "${aws_cloudfront_distribution.distribution_speech_api.domain_name}"
}
