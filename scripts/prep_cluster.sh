#!/usr/bin/env bash

set -x  # Echo commands
set -u  # Nounset

# export PROJECT_ID=[gcp_project_id]
gcloud config set project $PROJECT_ID
gcloud services enable container.googleapis.com
gcloud beta container clusters create "climate-engine-1" --zone "us-central1-c" --machine-type "e2-medium" --num-nodes "1" --node-locations "us-central1-c"
gcloud container clusters get-credentials climate-engine-1 --zone "us-central1-c"
gcloud iam service-accounts create climate-engine --display-name="Climate Engine Service Account"
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:climate-engine@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/owner"
gcloud iam service-accounts keys create climate-engine-${PROJECT_ID}.json --iam-account=climate-engine@${PROJECT_ID}.iam.gserviceaccount.com
kubectl create secret generic google-cloud-key --from-file=key.json=climate-engine-${PROJECT_ID}.json
rm climate-engine-${PROJECT_ID}.json