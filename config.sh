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
APP_VERSION=v0.0.1-alpha${BUILD_NUM}

##
# TAGS
##

# Repository tags/branchs
# Tags should always be used for production deployments
# Branches can be used for development deployments
A6T_TAG=main
BRANCH=test123

##
# Repositories
##

GITHUB_ORG_URL=https://github.com/ucd-library

# ARGONAUT - A6T
A6T_REPO_NAME=argonaut
A6T_REPO_URL=$GITHUB_ORG_URL/$A6T_REPO_NAME

# TASKS
CASITA_TASKS_REPO_NAME=casita-krm-tasks
CASITA_TASKS_REPO_URL=$GITHUB_ORG_URL/${CASITA_TASKS_REPO_NAME}

##
# Registery
##

if [[ -z $A6T_REG_HOST ]]; then
  A6T_REG_HOST=gcr.io/ucdlib-pubreg

  # set local-dev tags used by 
  # local development docker-compose file
  if [[ ! -z $LOCAL_BUILD ]]; then
    A6T_REG_HOST=localhost/local-dev
  fi
fi

##
# NodeJS
##
NODE_VERSION=16

##
# Container
##

AIRFLOW_WORKER_IMAGE_NAME=apache/airflow:2.2.4

CONTAINER_CACHE_TAG="latest"

# Container Images
A6T_IMAGE_NAME=$A6T_REG_HOST/argonaut
CASITA_IMAGE_NAME=$A6T_REG_HOST/casita
CASITA_A6T_IMAGE_NAME=$A6T_REG_HOST/casita-a6t-controller
CASITA_AIRFLOW_WORKER_NAME=$A6T_REG_HOST/casita-airflow-worker

A6T_IMAGE_NAME_TAG=$A6T_IMAGE_NAME:$A6T_TAG
CASITA_IMAGE_NAME_TAG=$CASITA_IMAGE_NAME:$APP_VERSION
CASITA_A6T_IMAGE_NAME_TAG=$CASITA_A6T_IMAGE_NAME:$APP_VERSION
CASITA_AIRFLOW_WORKER_NAME_TAG=$CASITA_AIRFLOW_WORKER_NAME:$APP_VERSION

ALL_DOCKER_BUILD_IMAGES=( $A6T_IMAGE_NAME \
 $CASITA_A6T_IMAGE_NAME $CASITA_AIRFLOW_WORKER_NAME )

ALL_DOCKER_BUILD_IMAGE_TAGS=( $A6T_IMAGE_NAME_TAG \
 $CASITA_A6T_IMAGE_NAME_TAG \
 $CASITA_AIRFLOW_WORKER_NAME_TAG )

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

IMAGE_PULL_POLICY="Always"
if [[ ! -z $LOCAL_BUILD ]]; then
  IMAGE_PULL_POLICY="IfNotPresent"
fi