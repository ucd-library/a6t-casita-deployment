#! /bin/bash

######### DEPLOYMENT CONFIG ############
# Setup your application deployment here
########################################

# Grab build number is mounted in CI system
if [[ -f /config/.buildenv ]]; then
  source /config/.buildenv
else
  BUILD_NUM=-1
fi

# Main version number we are tagging the app with. Always update
# this when you cut a new version of the app!
APP_VERSION=v0.0.1-alpha.${BUILD_NUM}

##
# TAGS
##

# Repository tags/branchs
# Tags should always be used for production deployments
# Branches can be used for development deployments
A6T_TAG=main

REDIS_TAG=6.0.5
ZOOKEEPER_TAG=3.6
KAFKA_TAG=2.5.0

##
# Repositories
##

GITHUB_ORG_URL=https://github.com/ucd-library

# ARGONAUT A6T
A6T_REPO_NAME=argonaut
A6T_REPO_URL=$GITHUB_ORG_URL/$A6T_REPO_NAME

##
# Registery
##

A6T_REG_HOST=gcr.io/ucdlib-pubreg

# set local-dev tags used by 
# local development docker-compose file
if [[ ! -z $LOCAL_BUILD ]]; then
  A6T_REG_HOST=localhost/local-dev
fi

##
# Container
##

CONTAINER_CACHE_TAG="latest"

# Container Images
A6T_IMAGE_NAME=$A6T_REG_HOST/argonaut
CASITA_A6T_IMAGE_NAME=$A6T_REG_HOST/casita-a6t
CASITA_DECODER_IMAGE_NAME=$A6T_REG_HOST/casita-a6t-decoder

A6T_IMAGE_NAME_TAG=$A6T_IMAGE_NAME:$A6T_TAG
CASITA_A6T_IMAGE_NAME_TAG=$CASITA_A6T_IMAGE_NAME:$APP_VERSION
CASITA_DECODER_IMAGE_NAME_TAG=$CASITA_DECODER_IMAGE_NAME:$APP_VERSION

REDIS_IMAGE_NAME=redis
ZOOKEEPER_IMAGE_NAME=zookeeper
KAFKA_IMAGE_NAME=bitnami/kafka

ALL_DOCKER_BUILD_IMAGES=( $A6T_IMAGE_NAME \
 $CASITA_A6T_IMAGE_NAME $CASITA_DECODER_IMAGE_NAME )

ALL_DOCKER_BUILD_IMAGE_TAGS=( $A6T_IMAGE_NAME_TAG \
 $CASITA_A6T_IMAGE_NAME_TAG $CASITA_DECODER_IMAGE_NAME_TAG )

##
# Git
##

ALL_GIT_REPOSITORIES=( $A6T_REPO_NAME )
ALL_GIT_REPOSITORY_TAGS=( "$A6T_REPO_NAME@$A6T_TAG" )

GIT=git
GIT_CLONE="$GIT clone"

# directory we are going to cache our various git repos at different tags
# if using pull.sh or the directory we will look for repositories (can by symlinks)
# if local development
REPOSITORY_DIR=repositories