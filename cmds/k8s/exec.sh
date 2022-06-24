#! /bin/bash

set -e

POD=$(kubectl get pods -l $@ -o jsonpath --template='{.items[*].metadata.name}')
echo "Connecting to pod: $POD"

kubectl exec --tty --stdin $POD -- bash