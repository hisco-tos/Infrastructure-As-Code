# Infrastructure-As-Code
An infrastructure deployment project featuring a two-tier application hosted on AWS Elastic Container Service (ECS), designed according to the AWS Well-Architected Framework, and completely automated using Terraform for provisioning and lifecycle management.

This repository contains a Terraform example that provisions EC2 instances on AWS. It demonstrates safe provider configuration, dynamic AMI lookup, and local credential integration for development.


What was verified
- Verified Terraform can run in the dev container (Terraform v1.14.3 installed).
- Verified provider initialization with `terraform init` completed successfully.
- Verified `terraform plan` using a local `vscode` AWS profile; plan showed EC2 resources to create.

Resources created (planned)
- Two `t2.micro` EC2 instances (Terraform plan indicated two instances would be created in the verification run).
- AMI selection uses a `data "aws_ami"` lookup to pick the most recent Canonical Ubuntu 20.04 AMI in the configured region.

Credentials & provider notes
- Provider is driven by variables and environment/profile credentials. The provider in `main.tf` uses:
  - `var.aws_region` (default `us-east-1`)
  - `var.aws_profile` (default `vscode` in verification)
- Credentials may come from:
  - Environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`
  - AWS credentials file: `~/.aws/credentials` (profile names)
  - Instance metadata (when running on EC2)
- For local verification I created a `vscode` profile in `~/.aws/credentials` from the existing `.env` and ran Terraform with `TF_VAR_aws_profile=vscode`.

How to reproduce verification locally
1. Copy `.env.example` to `.env` and fill in your credentials, or create a `vscode` profile in `~/.aws/credentials`.
2. Load environment variables into your shell:

```bash
source ./load-aws-env.sh
```

3. Initialize Terraform:

```bash
terraform init
```

4. Run plan (using the `vscode` profile example):

```bash
TF_VAR_aws_profile=vscode terraform plan
```

5. To create the planned resources:

```bash
terraform apply
```

Notes & recommendations
- Do NOT commit real credentials. `.env` is ignored by git and a `.env.example` is provided.
- For production, prefer IAM roles or a secrets manager instead of storing credentials in files.
- If you already have EC2 instances you want to preserve, use `terraform import` to bring them into Terraform state rather than applying which may recreate resources.


