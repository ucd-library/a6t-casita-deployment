#! /bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source ../../config.sh

gcloud config set project ${GC_PROJECT_ID}
gcloud secrets versions access latest --secret=casita-service-account > ../../service-account.json
gcloud secrets versions access latest --secret=grb-box-ssh-key > ../../ssh.key
gcloud secrets versions access latest --secret=grb-box-ssh-username > ../../ssh.username
gcloud secrets versions access latest --secret=casita-jwt-secret > ../../jwt-secret

echo "Setting secrets for ${GKE_CLUSTER_NAME}"

# setup kubectl to connect to cluster
./setup-kubectl.sh

kubectl delete secret decoder-ssh-user || true
kubectl create secret generic decoder-ssh-user --from-file=value=../../ssh.username

kubectl delete secret decoder-ssh-key || true
kubectl create secret generic decoder-ssh-key --from-file=ssh.key=../../ssh.key || true

kubectl delete secret service-account || true
kubectl create secret generic service-account --from-file=service-account.json=../../service-account.json || true

kubectl delete secret jwt-secret || true
kubectl create secret generic jwt-secret --from-file=value=../../jwt-secret || true
