# Climate Engine GCP Marketplace Deployer


## Pre Installation

  1. Create a minimal GKE cluster (installation will expand the cluster as needed)
  1. [Connect to the cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#generate_kubeconfig_entry)
     so that `kubectl` commands work
  1. [Create a Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
     in the project and [assign the role](https://cloud.google.com/iam/docs/granting-changing-revoking-access)
     `roles/owner`
  1. [Create](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) (and download)
     a json key for the service account
  1. Create a Kubernetes secret containing the json key by running the following: 
     `kubectl create secret generic google-cloud-key --from-file=key.json=PATH-TO-KEY-FILE.json`
     

## Marketplace Install
Follow instructions on GCP Marketplace

## Manual Install

## Development Install
  1. `gcloud config set project $TEST_PROJECT_ID`
  2. Install the Application CRD: `kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"`
  3. `mpdev install --deployer=gcr.io/ce-deployment/deployer --parameters='{"app_name": "test-deployment", "namespace": "test-ns", "sql_password": "asdfasdfasdf", "sa_secret_name": "google-cloud-key" }'`



## Licence
Copyright (c) 2021 Climate Engine

All information, content, and source code contained herein is, 
and remains the property of Climate Engine, Inc. and its suppliers,
if any. The intellectual and technical concepts contained herein 
are proprietary to Climate Engine, Inc. and its suppliers and may
be covered by U.S. and foreign Patents, patents in process, and 
protected by trade secret or copyright law. Dissemination of this 
information, content, and source code, or reproduction of such 
material is strictly forbidden unless prior written permission is 
obtained from Climate Engine, Inc.
