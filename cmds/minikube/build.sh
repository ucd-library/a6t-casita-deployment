#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

echo "building images in minikube vm"

eval $(minikube docker-env)

../build-local-dev.sh