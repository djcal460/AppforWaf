#!/bin/sh

set -e

#apk add --update jq

ls -ltr
cd source/${project_path}/fargate/terraform
echo -e "\ns3bucket = \"${S3BUCKET}\"" >> terraform.tfvars
cat terraform.tfvars
terraform -v
terraform init -backend-config="bucket=${S3BUCKET}" -backend-config="region=us-east-1" -backend-config="key=fargate.tfstate" -backend-config "workspace_key_prefix=frame/web-tier/tf-state"
terraform workspace select ${WORKSPACE} || terraform workspace new ${WORKSPACE}
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars -auto-approve