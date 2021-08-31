# Climate Engine GCP Marketplace Deployer


## Installation

  1. Create a minimal GKE cluster (Autopilot is sufficient)
  2. [Connect to the cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#generate_kubeconfig_entry)
     so that `kubectl` commands work
  3. [Create a Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
     in the project and [assign the role](https://cloud.google.com/iam/docs/granting-changing-revoking-access)
     `roles/owner`
  4. [Create](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) (and download)
     a json key for the service account
  5. Create a Kubernetes secret containing the json key by running the following: 
     `kubectl create secret generic google-cloud-key --from-file=key.json=PATH-TO-KEY-FILE.json`
  6. Follow instructions on GCP Marketplace listing

### Command Line Install

  1. `export PROJECT_ID=[project_id]`
  2. `gcloud config set project $PROJECT_ID`
  3. Create GKE cluster:
     ```shell
     gcloud services enable container.googleapis.com
     gcloud beta container clusters create "climate-engine-1" --zone "us-central1-c" --machine-type "e2-medium" --num-nodes "1" --node-locations "us-central1-c" 
     ```
  4. Connect to cluster:
     ```shell
     gcloud container clusters get-credentials climate-engine-1 --zone "us-central1-c"
     ```
  5. Create Service account:
     ```shell
     gcloud iam service-accounts create climate-engine --display-name="Climate Engine Service Account"
     ```
  6. Grant `roles/owner` on service account:
     ```shell
     gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:climate-engine@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/owner"
     ```  
  7. Generate json key:
     ```shell
     gcloud iam service-accounts keys create \
       climate-engine-${PROJECT_ID}.json \
       --iam-account=climate-engine@${PROJECT_ID}.iam.gserviceaccount.com
     ```
  8. Add JSON key to GKE:
     ```shell
     kubectl create secret generic google-cloud-key --from-file=key.json=climate-engine-${PROJECT_ID}.json
     ```  
  9. Follow instructions on GCP Marketplace

## Marketplace Install
Follow instructions on GCP Marketplace

## Development Install
  1. `export PROJECT_ID=[project_id]`
  2. `gcloud config set project $PROJECT_ID`
  3. Create GKE cluster (Autopilot does *not* work):
     ```shell
     gcloud services enable container.googleapis.com
     gcloud beta container clusters create "climate-engine-1" --zone "us-central1-c" --machine-type "e2-medium" --num-nodes "1" --node-locations "us-central1-c" 
     ```
  4. Connect to cluster:
     ```shell
     gcloud container clusters get-credentials climate-engine-1 --zone "us-central1-c"
     ```
  5. Install the Application CRD:
     ```shell
     kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"
     ```
  6. Create Service account:
     ```shell
     gcloud iam service-accounts create climate-engine --display-name="Climate Engine Service Account"
     ```
  7. Grant `roles/owner` on service account:
     ```shell
     gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:climate-engine@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/owner"
     ```  
  8. Generate json key:
     ```shell
     gcloud iam service-accounts keys create \
       climate-engine-${PROJECT_ID}.json \
       --iam-account=climate-engine@${PROJECT_ID}.iam.gserviceaccount.com
     ```
  9. Add JSON key to GKE:
     ```shell
     kubectl create secret generic google-cloud-key --from-file=key.json=climate-engine-${PROJECT_ID}.json
     ```  
  10. Add fake billing key to k8s:
      ```shell
      gsutil cp gs://cloud-marketplace-tools/reporting_secrets/fake_reporting_secret.yaml .
      echo "metadata: {name: fake-reporting-secret}" >> fake_reporting_secret.yaml
      kubectl apply -f fake_reporting_secret.yaml
      ```
  11. Dev install:
      ```shell
      mpdev install --deployer=gcr.io/ce-deployment/deployer --parameters='{"app_name": "test-deployment", "namespace": "default", "sql_password": "asdfasdfasdf", "sa_secret_name": "google-cloud-key" }'
      ```


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
