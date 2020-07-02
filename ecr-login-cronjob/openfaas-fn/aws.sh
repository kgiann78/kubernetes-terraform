#!/usr/bin/env bash
DIR=$(dirname $0)
cd $DIR

echo "Recreating aws-secrets"
kubectl delete -n openfaas-fn -f ./aws-secrets.yml || true
kubectl create -n openfaas-fn -f ./aws-secrets.yml

echo "Recreating aws-role"
kubectl delete -n openfaas-fn -f ./aws-role.yml || true
kubectl create -n openfaas-fn -f ./aws-role.yml

echo "Recreating aws-ecr-cron"
kubectl delete -n openfaas-fn -f ./ecr-cron.yml || true
kubectl create -n openfaas-fn -f ./ecr-cron.yml
