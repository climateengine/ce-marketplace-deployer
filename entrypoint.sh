#!/usr/bin/env bash

# Echo commands
set -x
# Exit when any command fails
#set -e

gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

PROJECT_ID=$(gcloud config list --format 'value(core.project)')
PROJECT_NAME=$(printf "y" | gcloud projects describe ${PROJECT_ID} --format="value(name)")
gcloud config set project "$PROJECT_ID"

rm -rf .terraform*

# Create bucket if doesn't exist
gsutil ls -b gs://${PROJECT_ID}-ce-deployment || gsutil mb -b on gs://${PROJECT_ID}-ce-deployment

ls .
sed -i "s/bucket.*/bucket = \"${PROJECT_ID}-ce-deployment\"/g" terraform.tf
cat terraform.tf

echo project_id = \"${PROJECT_ID}\" > terraform.tfvars
echo project_name = \"${PROJECT_NAME}\" >> terraform.tfvars
echo app_name = \"${APP_NAME}\" >> terraform.tfvars
echo namespace = \"${NAMESPACE}\" >> terraform.tfvars
echo cloud_sql_pass = \"${SQL_PASSWORD}\" >> terraform.tfvars
echo agent_encoded_key = \"${AGENT_ENCODED_KEY}\" >> terraform.tfvars
echo agent_consumer_id = \"${AGENT_CONSUMER_ID}\" >> terraform.tfvars
echo image_ubbagent = \"${IMAGE_UBBAGENT:=gcr.io/cloud-marketplace-tools/metering/ubbagent:latest}\" >> terraform.tfvars

cat terraform.tfvars

terraform init -no-color
sleep 60
terraform apply -auto-approve -no-color
