#! /bin/bash

###
# Main build process to cutting production images
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

A6T_REPO_HASH=$(git -C $REPOSITORY_DIR/$A6T_REPO_NAME log -1 --pretty=%h)

##
# Harvest
##

docker build \
  -t $HARVEST_IMAGE_NAME_TAG \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --cache-from=$HARVEST_IMAGE_NAME:$CONTAINER_CACHE_TAG \
  $REPOSITORY_DIR/$HARVEST_REPO_NAME
