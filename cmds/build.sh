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
# NodeJS base task and services image
##
echo "Building $CASITA_IMAGE_NAME_TAG"
docker build \
  -t $CASITA_IMAGE_NAME_TAG \
  -t $CASITA_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  --build-arg NODE_VERSION=${NODE_VERSION} \
  --cache-from=$CASITA_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  -f ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/Dockerfile.nodejs-base \
  ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}

# a6t controller
echo "Building $CASITA_A6T_IMAGE_NAME_TAG"
docker build \
  -t $CASITA_A6T_IMAGE_NAME_TAG \
  -t $CASITA_A6T_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  --build-arg A6T_CONTROLLER_BASE=${A6T_IMAGE_NAME_TAG} \
  --build-arg NODE_BASE=${CASITA_IMAGE_NAME_TAG} \
  --cache-from=$CASITA_A6T_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  -f ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/Dockerfile.a6t-controller \
  ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}

# airflow worker
echo "Building $CASITA_AIRFLOW_WORKER_NAME_TAG"
docker build \
  -t $CASITA_AIRFLOW_WORKER_NAME_TAG \
  -t $CASITA_AIRFLOW_WORKER_NAME:$CONTAINER_CACHE_TAG \
  --build-arg NODE_BASE=${CASITA_IMAGE_NAME_TAG} \
  --build-arg NODE_VERSION=${NODE_VERSION} \
  --build-arg AIRFLOW_WORKER_BASE=${AIRFLOW_WORKER_IMAGE_NAME} \
  --cache-from=$CASITA_AIRFLOW_WORKER_NAME:$CONTAINER_CACHE_TAG \
  -f ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/Dockerfile.airflow-worker \
  ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}