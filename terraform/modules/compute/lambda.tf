data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_handler"
  output_path = "${path.module}/lambda_handler.zip"
}

resource "aws_lambda_function" "text_to_mp3" {
  filename         = "${path.module}/lambda_handler.zip"
  handler          = "lambda_handler.text_to_mp3"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "aws_polly-TextToMP3"
  role             = "${aws_iam_role.lambda_polly.arn}"
  runtime          = "python3.6"
  timeout          = 30
}

resource "aws_lambda_permission" "api_gateway_speech_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.text_to_mp3.arn}"
  principal     = "apigateway.amazonaws.com"
  statement_id  = "text_to_mp3"
  source_arn    = "${var.source_arn_speech_get}"
}

resource "aws_iam_role" "lambda_polly" {
  name = "lambda_to_polly"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Sid": "",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attach_polly_full_access" {
  role       = "${aws_iam_role.lambda_polly.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonPollyFullAccess"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
resource "aws_lambda_function" "describe" {
  filename         = "${path.module}/lambda_handler.zip"
  handler          = "lambda_handler.describe_voices"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "aws_polly-DescribeVoices"
  role             = "${aws_iam_role.lambda_polly.arn}"
  runtime          = "python3.6"
  timeout          = 30
}

resource "aws_lambda_permission" "api_gateway_describe_get" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.describe.arn}"
  principal     = "apigateway.amazonaws.com"
  statement_id  = "describe"
  source_arn    = "${var.source_arn_voices_get}"
}
