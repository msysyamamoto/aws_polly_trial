variable "account_id" {}
variable "lambda_function_invoke_arn" {}
variable "lambda_function_invoke_arn_describe_voices" {}
variable "region" {}
variable "s3_bucket_domain_name" {}
variable "s3_bucket_name" {}

variable "whitelisted_ips" {
  type = "list"
}
