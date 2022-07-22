#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../..

source ./config.sh

kubectl apply -f $DEPLOYMENT_DIR/nfs-volume.yaml
kubectl apply -f $DEPLOYMENT_DIR/nfs-volume-claim.yaml