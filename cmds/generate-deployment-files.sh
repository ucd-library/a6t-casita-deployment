#! /bin/bash

##
# Generate docker-compose deployment and local development files based on
# config.sh parameters
##

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../templates

if ! command -v cork-templates &> /dev/null
then
    echo -e "\nThe cork-template command could not be found.\nInstall via \"npm install -g @ucd-lib/cork-template\"\n"
    exit -1
fi

# generate main dc file
cork-template \
  -c ../config.sh \
  -t ../templates/deployment.yaml \
  -o ../docker-compose.yaml

# generate local development dc file
cork-template \
  -c ../config.sh \
  -t ../templates/local-dev.yaml \
  -o ../a6t-casita-local-dev/docker-compose.yaml

# generate local helm values files
cork-template \
  -c ../config.sh \
  -t ../templates/airflow-values.yaml \
  -o ../a6t-casita-local-dev/airflow-values.yaml

cork-template \
  -c ../config.sh \
  -c ../templates/data/status.json \
  -t ../templates/casita-services.yaml \
  -o ../a6t-casita-local-dev/status-deployment.yaml

cork-template \
  -c ../config.sh \
  -c ../templates/data/decoder.json \
  -t ../templates/casita-services.yaml \
  -o ../a6t-casita-local-dev/k8s/decoder-deployment.yaml
