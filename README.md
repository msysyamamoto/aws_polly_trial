# aws_polly_trial

## Terraform

### init

```
$ cd terraform/environments
$ terraform init \
    -backend-config="bucket={your bucket name}" \  # e.g., -backend-config="key=my-tfstate-bucket"
    -backend-config="key={your object key}" \      # e.g., -backend-config="key=terraform.tfstate"
    -backend-config="region={bucket region}"       # e.g., -backend-config="region=us-west-2" 
```
### Plan & Apply

```
$ cd terraform/environments
$ terraform plan
$ terraform apply
```

## Web

### Upload HTML

Upload `web/index.html` to S3 bucket. 

The bucket name is `polly-trial-{region}-{aws_account_id}`. For instance `polly-trial-us-east-1-0123456789ab`.

```
$ aws s3 cp web/index.html s3://polly-trial-{region}-{aws_account_id}/
```

### URL

```
https://{cloudfront domain}/index.html
```