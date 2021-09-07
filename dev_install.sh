#!/usr/bin/env bash

bash ./prep_cluster.sh

kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"
kubectl apply -f fake_reporting_secret.yaml
docker pull gcr.io/ce-deployment/deployer:latest
mpdev install --deployer=gcr.io/ce-deployment/deployer --parameters='{"app_name": "test-deployment", "namespace": "default", "sql_password": "asdfasdfasdf", "sa_secret_name": "google-cloud-key" }'
