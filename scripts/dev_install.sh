#!/usr/bin/env bash

set -x  # Echo commands
set -u  # Nounset
set -e  # Exit on first error

bash ./prep_cluster.sh

kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"
kubectl apply -f fake_reporting_secret.yaml
docker pull gcr.io/ce-deployment/deployer:latest
mpdev verify --deployer=gcr.io/ce-deployment/deployer
mpdev install --deployer=gcr.io/ce-deployment/deployer \
  --parameters='{"app_name": "test-deployment", "namespace": "default", "global.sa_secret_name": "google-cloud-key"}'
