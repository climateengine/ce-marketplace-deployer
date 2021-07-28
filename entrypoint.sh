#!/usr/bin/env bash

# Echo commands
set -x
# Exit when any command fails
set -e

gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

PROJECT_ID=$(gcloud config list --format 'value(core.project)')
PROJECT_NAME=$(gcloud projects describe ${PROJECT_ID} --format="value(name)")
gcloud config set project "$PROJECT_ID"

rm -rf .terraform*

gsutil mb -b on gs://${PROJECT_ID}-ce-deployment
sed -i "s/bucket.*/bucket = \"${PROJECT_ID}-ce-deployment\"/g" terraform.tf

echo project_id = \"${PROJECT_ID}\" > terraform.tfvars
echo project_name = \"${PROJECT_NAME}\" >> terraform.tfvars
echo app_name = \"${APP_NAME}\" >> terraform.tfvars
echo namespace = \"${NAMESPACE}\" >> terraform.tfvars
echo cloud_sql_pass = \"${SQL_PASSWORD}\" >> terraform.tfvars

terraform init
terraform apply -auto-approve
