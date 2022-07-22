#! /bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

source ../../config.sh

helm upgrade \
  --install kafka bitnami/kafka \
  --version 16.3.0 \
  -f $DEPLOYMENT_DIR/kafka-values.yaml