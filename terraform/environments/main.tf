data "aws_caller_identity" "current" {}

module "network" {
  source = "../modules/network"

  region          = "${var.region}"
  account_id      = "${data.aws_caller_identity.current.account_id}"
  whitelisted_ips = "${var.whitelisted_ips}"

  lambda_function_invoke_arn                 = "${module.compute.lambda_function_invoke_arn_text_to_mp3}"
  lambda_function_invoke_arn_describe_voices = "${module.compute.lambda_function_invoke_arn_describe_voices}"

  s3_bucket_name        = "${module.strage.s3_bucket_name}"
  s3_bucket_domain_name = "${module.strage.s3_bucket_domain_name}"
}

module "compute" {
  source = "../modules/compute"

  region                = "${var.region}"
  account_id            = "${data.aws_caller_identity.current.account_id}"
  source_arn_speech_get = "${module.network.source_arn_speech_get}"
  source_arn_voices_get = "${module.network.source_arn_voices_get}"
}

module "strage" {
  source = "../modules/strage"

  region                  = "${var.region}"
  account_id              = "${data.aws_caller_identity.current.account_id}"
  access_identity_iam_arn = "${module.network.access_identity_iam_arn}"
}
