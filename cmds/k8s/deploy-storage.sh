#! /bin/bash

###
# Build images for local development.  They will be tagged with local-dev and are
# meant to be used with ./rp-local-dev/docker-compose.yaml
# Note: these images should never be pushed to docker hub 
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../..

DEPLOYMENT_DIR=a6t-casita-local-dev/k8s
cd $DEPLOYMENT_DIR

kubectl apply -f nfs-storage-claim.yaml