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
