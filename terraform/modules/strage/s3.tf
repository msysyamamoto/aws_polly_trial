resource "aws_s3_bucket" "static_contents" {
  bucket        = "static-contents-${var.region}-${var.account_id}"
  region        = "${var.region}"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "static_contents" {
  bucket = "${aws_s3_bucket.static_contents.id}"
  policy = "${data.template_file.s3_bucket_policy.rendered}"
}

data "template_file" "s3_bucket_policy" {
  template = "${file("${path.module}/s3_bucket_policy.tpl.json")}"

  vars {
    bucket_name = "${aws_s3_bucket.static_contents.bucket}"
    iam_arn     = "${var.access_identity_iam_arn}"
  }
}
