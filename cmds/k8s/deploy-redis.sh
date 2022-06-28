#! /bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

source ../../config.sh

helm upgrade \
  --install redis bitnami/redis \
  -f $DEPLOYMENT_DIR/redis-values.yaml