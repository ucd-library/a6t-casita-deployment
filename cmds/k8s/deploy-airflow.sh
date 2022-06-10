#! /bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

source ../../config.sh

helm upgrade \
 --install airflow apache-airflow/airflow \
 --set images.airflow.repository=${CASITA_AIRFLOW_WORKER_NAME} \
 --set images.airflow.pullPolicy=${IMAGE_PULL_POLICY} \
 --set images.airflow.tag=${APP_VERSION} \
 -f $DEPLOYMENT_DIR/airflow-values.yaml