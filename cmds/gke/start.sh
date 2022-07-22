#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

export LOCAL_DEV=true
source ../../config.sh

../k8s/install-helm-repos.sh
./deploy-storage.sh || true
../k8s/deploy-kafka.sh || true
../k8s/deploy-redis.sh || true
../k8s/deploy-postgres.sh || true
../k8s/deploy-casita.sh || true