#! /bin/bash

###
# Main build process to cutting production images
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

CASITA_A6T_REPO_HASH=$(git log -1 --pretty=%h)

##
# composer
##
docker build \
  -t $CASITA_A6T_IMAGE_NAME_TAG \
  -t $CASITA_A6T_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  --build-arg A6T_BASE=${A6T_IMAGE_NAME_TAG} \
  --cache-from=$CASITA_A6T_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  containers/casita-a6t

# decoder
docker build \
  -t $CASITA_DECODER_IMAGE_NAME_TAG \
  -t $CASITA_DECODER_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  --build-arg A6T_BASE=${A6T_IMAGE_NAME_TAG} \
  --cache-from=$CASITA_DECODER_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  containers/decoder

# a6t-casita-local-dev
docker build \
  -t $CASITA_AIRFLOW_WORKER_NAME_TAG \
  -t $CASITA_AIRFLOW_WORKER_NAME:$CONTAINER_CACHE_TAG \
  --cache-from=$CASITA_AIRFLOW_WORKER_NAME:$CONTAINER_CACHE_TAG \
  ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/node-tasks