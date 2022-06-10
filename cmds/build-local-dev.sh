#! /bin/bash

###
# Build images for local development.  They will be tagged with local-dev and are
# meant to be used with ./rp-local-dev/docker-compose.yaml
# Note: these images should never be pushed to docker hub 
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

source ../config.sh

# build argonaut first
LOCAL_DEV=true NODE_VERSION=$NODE_VERSION ../$REPOSITORY_DIR/argonaut/build/run.sh

LOCAL_DEV=true ./build.sh