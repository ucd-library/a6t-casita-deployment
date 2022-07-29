#! /bin/bash

###
# Build images for local development.  They will be tagged with local-dev and are
# meant to be used with ./rp-local-dev/docker-compose.yaml
# Note: these images should never be pushed to docker hub 
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../..

source ./config.sh

kubectl rollout restart deployment decoder
kubectl rollout restart deployment a6t-composer
kubectl rollout restart deployment a6t-expire
kubectl rollout restart deployment worker
kubectl rollout restart deployment rest
kubectl rollout restart deployment external-topics
kubectl rollout restart deployment grb-product-writer
kubectl rollout restart deployment nfs-expire