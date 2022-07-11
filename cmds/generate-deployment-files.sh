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
  
  cork-template \
    -c ../config.sh \
    -t $TEMPLATE_ROOT/redis-values.yaml \
    -o $DEPLOYMENT_DIR/redis-values.yaml


  # Fake nfs storage
  cork-template \
    -c ../config.sh \
    -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
    -t $TEMPLATE_ROOT/minikube-nfs-storage.yaml \
    -o $DEPLOYMENT_DIR/minikube-nfs-storage.yaml

  # Storage claim
  cork-template \
    -c ../config.sh \
    -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
    -t $TEMPLATE_ROOT/nfs-storage-claim.yaml \
    -o $DEPLOYMENT_DIR/nfs-storage-claim.yaml

  # Decoder service
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/decoder.js \
      -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/decoder.yaml

  # Product writer service
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/product-writer.js \
      -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
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
    -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
    -t $TEMPLATE_ROOT/casita-deployment.yaml \
    -o $DEPLOYMENT_DIR/init-services-deployment.yaml

  # worker
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/casita-worker.js \
      -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/casita-worker.yaml

  # rest api
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/casita-rest.js \
      -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/casita-rest.yaml

  # rest api
  cork-template \
      -c ../config.sh \
      -c $TEMPLATE_ROOT/config/casita-external-topics.js \
      -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/casita-external-topics.yaml

  # postgres
  cork-template \
      -c ../config.sh \
      -t $TEMPLATE_ROOT/postgres.yaml \
      -o $DEPLOYMENT_DIR/postgres.yaml
  cp $TEMPLATE_ROOT/postgres-service.yaml $DEPLOYMENT_DIR/postgres-service.yaml


  # a6t services
  for file in $TEMPLATE_ROOT/config/casita-a6t-*.js; do 
    filename=$(basename $file)
    BASE=$(basename -- $filename .js)
    cork-template \
      -c ../config.sh \
      -c $file \
      -c $TEMPLATE_ROOT/config/casita-minikube-nfs.json \
      -t $TEMPLATE_ROOT/casita-deployment.yaml \
      -o $DEPLOYMENT_DIR/$BASE.yaml
  done

else

  echo "TODO: implement me"

fi


