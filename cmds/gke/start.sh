#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

source ../../config.sh

gcloud config set project ${GC_PROJECT_ID}
./setup-kubectl.sh

../k8s/install-helm-repos.sh
./deploy-storage.sh || true
../k8s/deploy-kafka.sh || true
../k8s/deploy-redis.sh || true
../k8s/deploy-postgres.sh || true
../k8s/deploy-rabbitmq.sh || true
../k8s/deploy-casita.sh || true

echo "sleeping for 1min to let cluster start"
sleep 60
../k8s/deploy-decoder.sh || true