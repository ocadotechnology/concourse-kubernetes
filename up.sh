#!/bin/bash
set -e

kubectl create -f manifests/concourse-postgresql-secrets.yaml
kubectl create -f manifests/concourse-postgresql-svc.yaml
kubectl create -f manifests/concourse-postgresql-deployment.yaml

kubectl create -f manifests/concourse-secrets.yaml
kubectl create -f manifests/concourse-web-svc.yaml
kubectl create -f manifests/concourse-web-deployment.yaml
kubectl create -f manifests/concourse-worker-deployment.yaml
