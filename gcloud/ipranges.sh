#! /bin/bash

set -e
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT_DIR

source ../config.sh

json=$(curl  -s https://www.gstatic.com/ipranges/cloud.json)
echo $json | jq -c ".prefixes | map(select(.scope == \"$GC_REGION\")) | .[].ipv4Prefix"