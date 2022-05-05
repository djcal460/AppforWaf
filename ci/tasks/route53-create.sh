#!/bin/sh

set -e

ls -ltr

#apk add --update jq

ls -ltr

cd source/${project_path}/route53/terraform
echo -e "\ns3bucket = \"${S3BUCKET}\"" >> terraform.tfvars
cat terraform.tfvars
ls -ltr
terraform -v
terraform init -backend-config="bucket=${S3BUCKET}" -backend-config="region=us-east-1" -backend-config="key=route53.tfstate" -backend-config "workspace_key_prefix=frame/web-tier/tf-state"
terraform workspace select ${WORKSPACE} || terraform workspace new ${WORKSPACE}
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars -auto-approve