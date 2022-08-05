#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../..

source config.sh

gcloud config set project ${GC_PROJECT_ID}
gcloud secrets versions access latest --secret=casita-service-account > service-account.json
gcloud secrets versions access latest --secret=grb-box-ssh-key > ./casita-local-dev/id_rsa

kubectl delete secret local-dev-secrets|| true
kubectl create secret generic local-dev-secrets --from-env-file=casita-local-dev/.env

kubectl delete secret service-account || true
kubectl create secret generic service-account --from-file=service-account.json=service-account.json || true