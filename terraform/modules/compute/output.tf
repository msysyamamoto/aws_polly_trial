output "lambda_function_invoke_arn_text_to_mp3" {
  value = "${aws_lambda_function.text_to_mp3.invoke_arn}"
}

output "lambda_function_invoke_arn_describe_voices" {
  value = "${aws_lambda_function.describe.invoke_arn}"
}
