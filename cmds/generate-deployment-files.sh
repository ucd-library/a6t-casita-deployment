#! /bin/bash

##
# Generate docker-compose deployment and local development files based on
# config.sh parameters
##

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR/../templates

source $ROOT_DIR/../config.sh
TEMPLATE_ROOT=../templates/k8s

if ! command -v cork-template &> /dev/null
then
    echo -e "\nThe cork-template command could not be found.\nInstall via \"npm install -g @ucd-lib/cork-template\"\n"
    exit -1
fi

# generate main dc file
# cork-template \
#   -c ../config.sh \
#   -t ../templates/deployment.yaml \
#   -o ../docker-compose.yaml

# generate local development dc file
# cork-template \
#   -c ../config.sh \
#   -t ../templates/local-dev.yaml \
#   -o ../a6t-casita-local-dev/docker-compose.yaml

if [[ $LOCAL_DEV == "true" ]]; then
  TEMPLATE_ROOT=$TEMPLATE_ROOT/local-dev
  echo "Generating local development files from $TEMPLATE_ROOT for $DEPLOYMENT_DIR"

  cp $TEMPLATE_ROOT/kafka-values.yaml $DEPLOYMENT_DIR/kafka-values.yaml

  cork-template \
    -c ../config.sh \
    -t $TEMPLATE_ROOT/redis-values.yaml \
    -o $DEPLOYMENT_DIR/redis-values.yaml

  # Fake nfs storage
  cork-template \
    -c ../config.sh \
    -c $TEMPLATE_ROOT/config/minikube-nfs.json \
    -t $TEMPLATE_ROOT/minikube-nfs-storage.yaml \
    -o $DEPLOYMENT_DIR/minikube-nfs-storage.yaml

  # Storage claim
  cork-template \
    -c ../config.sh \
    -c $TEMPLATE_ROOT/config/minikube-nfs.json \
    -t $TEMPLATE_ROOT/nfs-volume-claim.yaml \
    -o $DEPLOYMENT_DIR/nfs-volume-claim.yaml

  # Decoder service
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/decoder.js \
      -c $TEMPLATE_ROOT/config/minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/decoder.yaml

  # Product writer service
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/product-writer.js \
      -c $TEMPLATE_ROOT/config/minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/product-writer.yaml

  # Init service
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/init-services.js \
      -t $TEMPLATE_ROOT/job.yaml \
      -o $DEPLOYMENT_DIR/init-services.yaml
  # for debugging
  cork-template \
    -c ../config.sh \
    -c $TEMPLATE_ROOT/config/init-services-deployment.js \
    -c $TEMPLATE_ROOT/config/minikube-nfs.json \
    -t $TEMPLATE_ROOT/casita-deployment.yaml \
    -o $DEPLOYMENT_DIR/init-services-deployment.yaml

  # worker
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/worker.js \
      -c $TEMPLATE_ROOT/config/minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/worker.yaml

  # rest api
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/rest.js \
      -c $TEMPLATE_ROOT/config/minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/rest.yaml

  # rest api
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/external-topics.js \
      -c $TEMPLATE_ROOT/config/minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/external-topics.yaml

  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/nfs-expire.js \
      -c $TEMPLATE_ROOT/config/minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/nfs-expire.yaml

  cork-template \
      -c $TEMPLATE_ROOT/config/external-topics-service.json \
      -t $TEMPLATE_ROOT/service.yaml \
      -o $DEPLOYMENT_DIR/external-topics-service.yaml

  # postgres
  cork-template \
      -c ../config.sh \
      -t $TEMPLATE_ROOT/postgres.yaml \
      -o $DEPLOYMENT_DIR/postgres.yaml

  cork-template \
      -c $TEMPLATE_ROOT/config/postgres-service.json \
      -t $TEMPLATE_ROOT/service.yaml \
      -o $DEPLOYMENT_DIR/postgres-service.yaml

  # a6t services
  for file in $TEMPLATE_ROOT/config/a6t-*.js; do 
    filename=$(basename $file)
    BASE=$(basename -- $filename .js)
    cork-template \
      -c ../config.sh \
      -c $file \
      -c $TEMPLATE_ROOT/config/minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/$BASE.yaml
  done

else
  TEMPLATE_ROOT=$TEMPLATE_ROOT/prod
  echo "Generating GKE files from $TEMPLATE_ROOT for $DEPLOYMENT_DIR"

  rm -rf $DEPLOYMENT_DIR
  mkdir -p $DEPLOYMENT_DIR

  cp $TEMPLATE_ROOT/kafka-values.yaml $DEPLOYMENT_DIR/kafka-values.yaml

  cork-template \
    -c ../config.sh \
    -t $TEMPLATE_ROOT/redis-values.yaml \
    -o $DEPLOYMENT_DIR/redis-values.yaml

  # nfs storage
  cork-template \
    -c ../config.sh \
    -t $TEMPLATE_ROOT/nfs-volume.yaml \
    -o $DEPLOYMENT_DIR/nfs-volume.yaml

  # Storage claim
  cork-template \
    -c ../config.sh \
    -t $TEMPLATE_ROOT/nfs-volume-claim.yaml \
    -o $DEPLOYMENT_DIR/nfs-volume-claim.yaml

  # postgres
  cork-template \
      -c ../config.sh \
      -t $TEMPLATE_ROOT/postgres.yaml \
      -o $DEPLOYMENT_DIR/postgres.yaml

  cork-template \
      -c $TEMPLATE_ROOT/config/postgres-service.json \
      -t $TEMPLATE_ROOT/service.yaml \
      -o $DEPLOYMENT_DIR/postgres-service.yaml

  # Init service
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/init-services.js \
      -t $TEMPLATE_ROOT/job.yaml \
      -o $DEPLOYMENT_DIR/init-services.yaml

  # Decoder service
  cork-template \
    -c ../config.sh \
    -c $TEMPLATE_ROOT/config/decoder.js \
    -t $TEMPLATE_ROOT/decoder.yaml \
    -o $DEPLOYMENT_DIR/decoder.yaml

  # Product writer service
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/product-writer.js \
      -t $TEMPLATE_ROOT/deployment.yaml \
      -o $DEPLOYMENT_DIR/product-writer.yaml

  # worker
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/worker.js \
      -t $TEMPLATE_ROOT/deployment.yaml \
      -o $DEPLOYMENT_DIR/worker.yaml

  # rest api
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/rest.js \
      -t $TEMPLATE_ROOT/deployment.yaml \
      -o $DEPLOYMENT_DIR/rest.yaml

  # external topics api
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/external-topics.js \
      -t $TEMPLATE_ROOT/deployment.yaml \
      -o $DEPLOYMENT_DIR/external-topics.yaml

  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/nfs-expire.js \
      -t $TEMPLATE_ROOT/deployment.yaml \
      -o $DEPLOYMENT_DIR/nfs-expire.yaml

  cork-template \
      -c $TEMPLATE_ROOT/config/external-topics-service.json \
      -t $TEMPLATE_ROOT/service.yaml \
      -o $DEPLOYMENT_DIR/external-topics-service.yaml

  # a6t services
  for file in $TEMPLATE_ROOT/config/a6t-*.js; do 
    filename=$(basename $file)
    BASE=$(basename -- $filename .js)
    cork-template \
      -c ../config.sh \
      -c $file \
      -t $TEMPLATE_ROOT/deployment.yaml \
      -o $DEPLOYMENT_DIR/$BASE.yaml
  done

fi


