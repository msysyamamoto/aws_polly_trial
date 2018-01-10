output "s3_bucket_name" {
  value = "${aws_s3_bucket.static_contents.bucket}"
}

output "s3_bucket_domain_name" {
  value = "${aws_s3_bucket.static_contents.bucket_domain_name}"
}
