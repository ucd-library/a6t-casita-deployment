#! /bin/bash

###
# Main build process to cutting production images
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

# CASITA_A6T_REPO_HASH=$(cd $ROOT_DIR/$REPOSITORY_DIR/$A6T_REPO_NAME && log -1 --pretty=%h)

# build argonaut first
# TODO: move this to pre-built
NODE_VERSION=$NODE_VERSION $REPOSITORY_DIR/argonaut/build/run.sh
CACHE_TIME=720h

##
# NodeJS base task and services image
##
echo "Building $CASITA_IMAGE_NAME_TAG"
docker run --rm -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/kaniko/config.json:ro \
  -e GOOGLE_APPLICATION_CREDENTIALS=/kaniko/config.json \
  gcr.io/kaniko-project/executor:latest \
  --cache=true \
  --cache-ttl=${CACHE_TIME} \
  --snapshotMode=redo \
  --cache-copy-layers=true \
  --destination=$CASITA_IMAGE_NAME_TAG \
  --build-arg NODE_VERSION=${NODE_VERSION} \
  --context=/workspace/${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME} \
  --dockerfile=/workspace/${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/Dockerfile.nodejs-base

# init services
echo "Building $CASITA_INIT_IMAGE_NAME_TAG"
docker run --rm -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/kaniko/config.json:ro \
  -e GOOGLE_APPLICATION_CREDENTIALS=/kaniko/config.json \
  gcr.io/kaniko-project/executor:latest \
  --cache=true \
  --cache-ttl=${CACHE_TIME} \
  --snapshotMode=redo \
  --cache-copy-layers=true \
  --build-arg INIT_BASE=${INIT_BASE_IMAGE} \
  --build-arg NODE_BASE=${CASITA_IMAGE_NAME_TAG} \
  --destination=$CASITA_INIT_IMAGE_NAME_TAG \
  --context=/workspace/${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME} \
  --dockerfile=/workspace/${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/Dockerfile.init-services


# a6t controller
echo "Building $CASITA_A6T_IMAGE_NAME_TAG"
docker run --rm -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/kaniko/config.json:ro \
  -e GOOGLE_APPLICATION_CREDENTIALS=/kaniko/config.json \
  gcr.io/kaniko-project/executor:latest \
  --cache=true \
  --cache-ttl=${CACHE_TIME} \
  --snapshotMode=redo \
  --cache-copy-layers=true \
  --build-arg A6T_CONTROLLER_BASE=${A6T_IMAGE_NAME_TAG} \
  --build-arg NODE_BASE=${CASITA_IMAGE_NAME_TAG} \
  --destination=$CASITA_A6T_IMAGE_NAME_TAG \
  --context=/workspace/${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME} \
  --dockerfile=/workspace/${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/Dockerfile.a6t-controller


# postgis
echo "Building $CASITA_POSTGIS_IMAGE_NAME"
docker run --rm -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/kaniko/config.json:ro \
  -e GOOGLE_APPLICATION_CREDENTIALS=/kaniko/config.json \
  gcr.io/kaniko-project/executor:latest \
  --cache=true \
  --cache-ttl=${CACHE_TIME} \
  --snapshotMode=redo \
  --cache-copy-layers=true \
  --destination=$CASITA_POSTGIS_IMAGE_NAME_TAG \
  --context=/workspace/${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/services/postgis \
  --dockerfile=/workspace/${REPOSITORY_DIR}/${CASITA_TASKS_REPO_NAME}/services/postgis/Dockerfile 