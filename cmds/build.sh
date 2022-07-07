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

# init services
echo "Building $CASITA_INIT_IMAGE_NAME_TAG"
docker build \
  -t $CASITA_INIT_IMAGE_NAME_TAG \
  -t $CASITA_INIT_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  --build-arg INIT_BASE=${INIT_BASE_IMAGE} \
  --build-arg NODE_BASE=${CASITA_IMAGE_NAME_TAG} \
  --cache-from=$CASITA_INIT_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  -f ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/Dockerfile.init-services \
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

# postgis
echo "Building $CASITA_POSTGIS_IMAGE_NAME"
docker build \
  -t $CASITA_POSTGIS_IMAGE_NAME_TAG \
  -t $CASITA_POSTGIS_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  --cache-from=$CASITA_POSTGIS_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  -f ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/services/postgis/Dockerfile \
  ${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/services/postgis