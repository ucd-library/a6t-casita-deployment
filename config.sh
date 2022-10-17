#! /bin/bash

######### DEPLOYMENT CONFIG ############
# Setup your application deployment here
########################################

# CONFIG_ROOT_DIR="${BASH_SOURCE[0]}"
CONFIG_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TMP_LOC=$(pwd)
cd $CONFIG_ROOT_DIR/..
HOST_PATH=$(pwd)
HOME_HOST_PATH="${HOST_PATH#"$HOME"/}"
cd $TMP_LOC

# Grab build number is mounted in CI system
BUILD_NUM=""
if [[ -f /config/.buildenv ]]; then
  source /config/.buildenv
  BUILD_NUM=".${BUILD_NUM}"
fi

# Main version number we are tagging the app with. Always update
# this when you cut a new version of the app!
APP_VERSION=v2.0.0-beta${BUILD_NUM}

##
# TAGS
##

# Repository tags/branchs
# Tags should always be used for production deployments
# Branches can be used for development deployments
A6T_TAG=main
CASITA_TASKS_TAG=main
BRANCH=main

##
# Repositories
##

GITHUB_ORG_URL=https://github.com/ucd-library

# ARGONAUT - A6T
A6T_REPO_NAME=argonaut
A6T_REPO_URL=$GITHUB_ORG_URL/$A6T_REPO_NAME

# TASKS
CASITA_TASKS_REPO_NAME=casita-tasks
CASITA_TASKS_REPO_URL=$GITHUB_ORG_URL/${CASITA_TASKS_REPO_NAME}

##
# Registery
##

if [[ -z $A6T_REG_HOST ]]; then
  A6T_REG_HOST=gcr.io/ucdlib-pubreg

  # set local-dev tags used by 
  # local development docker-compose file
  if [[ $LOCAL_DEV == 'true' ]]; then
    A6T_REG_HOST=localhost/local-dev
  fi
fi

DOCKER_CACHE_TAG=latest

##
# NodeJS
##
NODE_VERSION=16

##
# Container
##

INIT_BASE_IMAGE=gcr.io/ucdlib-pubreg/init-services:main

# TODO: switch to branch
CONTAINER_CACHE_TAG="latest"

# Container Images
A6T_IMAGE_NAME=$A6T_REG_HOST/argonaut
CASITA_IMAGE_NAME=$A6T_REG_HOST/casita
CASITA_A6T_IMAGE_NAME=$A6T_REG_HOST/casita-a6t-controller
CASITA_INIT_IMAGE_NAME=$A6T_REG_HOST/casita-init
CASITA_POSTGIS_IMAGE_NAME=$A6T_REG_HOST/casita-postgis

A6T_IMAGE_NAME_TAG=$A6T_IMAGE_NAME:$A6T_TAG
CASITA_IMAGE_NAME_TAG=$CASITA_IMAGE_NAME:$APP_VERSION
CASITA_A6T_IMAGE_NAME_TAG=$CASITA_A6T_IMAGE_NAME:$APP_VERSION
CASITA_INIT_IMAGE_NAME_TAG=$CASITA_INIT_IMAGE_NAME:$APP_VERSION
CASITA_POSTGIS_IMAGE_NAME_TAG=$CASITA_POSTGIS_IMAGE_NAME:$APP_VERSION

ALL_DOCKER_BUILD_IMAGES=( $A6T_IMAGE_NAME \
 $CASITA_A6T_IMAGE_NAME $CASITA_POSTGIS_IMAGE_NAME 
 $CASITA_INIT_IMAGE_NAME $CASITA_IMAGE_NAME )

ALL_DOCKER_BUILD_IMAGE_TAGS=( $A6T_IMAGE_NAME_TAG \
 $CASITA_A6T_IMAGE_NAME_TAG $CASITA_IMAGE_NAME_TAG \
 $CASITA_POSTGIS_IMAGE_NAME_TAG \
 $CASITA_INIT_IMAGE_NAME_TAG  )

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

##
# k8s
##

# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
if [[ $LOCAL_DEV != 'true' ]]; then
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi

DEPLOYMENT_DIR=$CONFIG_ROOT_DIR/k8s
IMAGE_PULL_POLICY="Always"
LOCAL_DEV_DIR=casita-local-dev

if [[ $LOCAL_DEV == 'true' ]]; then
  IMAGE_PULL_POLICY="IfNotPresent"
  DEPLOYMENT_DIR=$CONFIG_ROOT_DIR/$LOCAL_DEV_DIR/k8s
fi

GKE_CLUSTER_NAME=casita
GC_PROJECT_ID=casita-298223
GC_REGION=us-central1
GC_ZONE=$GC_REGION-c
K8S_ENV=gce-prod
if [[ $LOCAL_DEV == 'true' ]]; then
  K8S_ENV=minikube
fi

# setting this to "log" generates a lot of logs,
# causes a pick spike in GC costs
K8S_LOG_LEVEL=info
K8S_DEPLOYMENT_CPU=250m

# Make sure our volume is in GC_ZONE
FILESTORE_PATH=/casita
FILESTORE_IP=10.196.120.130
FILESTORE_VOLUME_NAME=nfs-persistent-storage

API_SERVICE_INTERNAL_IP=10.128.0.57
# H2_SERVICE_INTERNAL_IP=10.128.0.27
# WS_SERVICE_INTERNAL_IP=10.128.0.16
# OPEN_KAFKA_WS_SERVICE_INTERNAL_IP=10.128.0.38