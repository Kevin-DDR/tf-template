# Terraform template for S3 webapp / site hosting
## Setup
Rename `.env.example` into `.env`

Edit `.env` to add your own keys

Change the default values for variables in `variables.tf`

- `cd terraform`

- `export $(grep -v '^#' ../.env | xargs)`

- `terraform init`

- `terraform plan`

- `terraform apply`

Once you've tested locally

- `terraform destroy`

Next you can create a Terraform Cloud project.

Connect the repo.

Add the .env variables in the project.

## Github action

Add: 
- `S3_NAME` (Same value as in `variables.tf`) to the public Github repo variables

- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to the secret Github repo variables



Edit `deploy.yml` to add your own custom build / lint / test phase.
