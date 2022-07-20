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

kubectl delete job init-services || true
kubectl apply -f $DEPLOYMENT_DIR/init-services.yaml

kubectl apply -f $DEPLOYMENT_DIR/a6t-composer.yaml
kubectl apply -f $DEPLOYMENT_DIR/a6t-expire.yaml
kubectl apply -f $DEPLOYMENT_DIR/worker.yaml
kubectl apply -f $DEPLOYMENT_DIR/rest.yaml
kubectl apply -f $DEPLOYMENT_DIR/external-topics.yaml
kubectl apply -f $DEPLOYMENT_DIR/external-topics-service.yaml
kubectl apply -f $DEPLOYMENT_DIR/decoder.yaml
kubectl apply -f $DEPLOYMENT_DIR/product-writer.yaml
kubectl apply -f $DEPLOYMENT_DIR/nfs-expire.yaml