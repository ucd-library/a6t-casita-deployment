#! /bin/bash

###
# Push docker image and $DOCKER_CACHE_TAG (currently :latest) tag to docker hub
###

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/..
source config.sh

docker push $A6T_IMAGE_NAME:$A6T_TAG
docker tag $A6T_IMAGE_NAME:$A6T_TAG $A6T_IMAGE_NAME:$CONTAINER_CACHE_TAG

docker push $CASITA_IMAGE_NAME_TAG
docker tag $CASITA_IMAGE_NAME:$A6T_TAG $CASITA_IMAGE_NAME:$CONTAINER_CACHE_TAG

docker push $CASITA_INIT_IMAGE_NAME_TAG
docker tag $CASITA_INIT_IMAGE_NAME_TAG $CASITA_INIT_IMAGE_NAME:$CONTAINER_CACHE_TAG

docker push $CASITA_A6T_IMAGE_NAME_TAG
docker tag $CASITA_A6T_IMAGE_NAME_TAG $CASITA_A6T_IMAGE_NAME:$CONTAINER_CACHE_TAG

docker push $CASITA_POSTGIS_IMAGE_NAME_TAG
docker tag $CASITA_POSTGIS_IMAGE_NAME_TAG $CASITA_POSTGIS_IMAGE_NAME:$CONTAINER_CACHE_TAG