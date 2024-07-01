# Terraform template for S3 webapp / site hosting

## Required env variables

## Export OVHcloud API credentials
$ export TF_VAR_AWS_ACCESS_KEY_ID="..."
$ export TF_VAR_AWS_SECRET_ACCESS_KEY="..."
$ export TF_VAR_APPLICATION_KEY="..."
$ export TF_VAR_APPLICATION_SECRET="..."
$ export TF_VAR_CONSUMER_KEY="..."

## Change the variables in variables.tf

export $(grep -v '^#' .env | xargs)

or (if you're in ./terraform/)

export $(grep -v '^#' ../.env | xargs)

`cd terraform`
`terraform init`
`terraform plan`
`terraform apply`
`terraform destroy`