resource "aws_api_gateway_rest_api" "speech_api" {
  name               = "Speech"
  binary_media_types = ["audio/mpeg"]
}

resource "aws_api_gateway_resource" "resource_speech" {
  rest_api_id = "${aws_api_gateway_rest_api.speech_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.speech_api.root_resource_id}"
  path_part   = "speech.mp3"
}

resource "aws_api_gateway_method" "method_speech_get" {
  rest_api_id      = "${aws_api_gateway_rest_api.speech_api.id}"
  resource_id      = "${aws_api_gateway_resource.resource_speech.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    method.request.querystring.text  = true
    method.request.querystring.voice = true
  }
}

resource "aws_api_gateway_integration" "integration_speech_get" {
  rest_api_id             = "${aws_api_gateway_rest_api.speech_api.id}"
  resource_id             = "${aws_api_gateway_resource.resource_speech.id}"
  http_method             = "${aws_api_gateway_method.method_speech_get.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"

  uri = "${var.lambda_function_invoke_arn}"

  request_templates {
    "application/json" = <<EOF
{
    "text" : "$input.params('text')",
    "voice" : "$input.params('voice')"
}
EOF
  }
}

resource "aws_api_gateway_method_response" "method_response_speech_get_200" {
  rest_api_id = "${aws_api_gateway_rest_api.speech_api.id}"
  resource_id = "${aws_api_gateway_resource.resource_speech.id}"
  http_method = "${aws_api_gateway_method.method_speech_get.http_method}"
  status_code = "200"

  response_models = {
    "audio/mpeg" = "Empty"
  }

  response_parameters = {
    "method.response.header.content-type" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_speech_get_200" {
  rest_api_id = "${aws_api_gateway_rest_api.speech_api.id}"
  resource_id = "${aws_api_gateway_resource.resource_speech.id}"
  http_method = "${aws_api_gateway_method.method_speech_get.http_method}"
  status_code = "${aws_api_gateway_method_response.method_response_speech_get_200.status_code}"

  depends_on       = ["aws_api_gateway_integration.integration_speech_get"]
  content_handling = "CONVERT_TO_BINARY"

  response_parameters = {
    "method.response.header.content-type" = "'audio/mpeg'"
  }
}

resource "aws_api_gateway_deployment" "deployment_beta" {
  rest_api_id = "${aws_api_gateway_rest_api.speech_api.id}"
  stage_name  = "beta"

  depends_on = [
    "aws_api_gateway_integration_response.integration_response_speech_get_200",
    "aws_api_gateway_integration_response.integration_response_voices_get_200",
  ]
}

resource "aws_api_gateway_api_key" "speech_api_key" {
  name = "speech_api_key"
}

resource "aws_api_gateway_usage_plan" "usage_plan_beta" {
  name        = "aws_polly_beta_plan"
  description = "Usege plan for AWS-Say API"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.speech_api.id}"
    stage  = "${aws_api_gateway_deployment.deployment_beta.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.speech_api_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.usage_plan_beta.id}"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
resource "aws_api_gateway_resource" "resource_voices" {
  rest_api_id = "${aws_api_gateway_rest_api.speech_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.speech_api.root_resource_id}"
  path_part   = "voices"
}

resource "aws_api_gateway_method" "method_voices_get" {
  rest_api_id      = "${aws_api_gateway_rest_api.speech_api.id}"
  resource_id      = "${aws_api_gateway_resource.resource_voices.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "integration_voices_get" {
  rest_api_id             = "${aws_api_gateway_rest_api.speech_api.id}"
  resource_id             = "${aws_api_gateway_resource.resource_voices.id}"
  http_method             = "${aws_api_gateway_method.method_voices_get.http_method}"
  type                    = "AWS"
  integration_http_method = "POST"

  uri = "${var.lambda_function_invoke_arn_describe_voices}"
}

resource "aws_api_gateway_method_response" "method_response_voices_get_200" {
  rest_api_id = "${aws_api_gateway_rest_api.speech_api.id}"
  resource_id = "${aws_api_gateway_resource.resource_voices.id}"
  http_method = "${aws_api_gateway_method.method_voices_get.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.content-type" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_voices_get_200" {
  rest_api_id = "${aws_api_gateway_rest_api.speech_api.id}"
  resource_id = "${aws_api_gateway_resource.resource_voices.id}"
  http_method = "${aws_api_gateway_method.method_voices_get.http_method}"
  status_code = "${aws_api_gateway_method_response.method_response_voices_get_200.status_code}"

  depends_on = ["aws_api_gateway_integration.integration_voices_get"]
}
