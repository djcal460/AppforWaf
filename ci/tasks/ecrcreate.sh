#!/bin/sh

set -e

#apk add --update jq

uname -a
ls -ltr
cd source/${project_path}/ecr/terraform
echo -e "\ns3bucket = \"${S3BUCKET}\"" >> terraform.tfvars
echo "s3 bucket" ${S3BUCKET}
cat terraform.tfvars
terraform -v
terraform init -backend-config="bucket=${S3BUCKET}" -backend-config="region=us-east-1" -backend-config="key=ecr.tfstate" -backend-config "workspace_key_prefix=frame/web-tier/tf-state"
terraform workspace select ${WORKSPACE} || terraform workspace new ${WORKSPACE}
terraform plan
terraform apply -auto-approve
export registry_uri=`terraform output Registry_URL`