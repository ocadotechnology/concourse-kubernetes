#!/bin/bash
set -e

kubectl create -f manifests/concourse-postgresql-secrets.yaml
kubectl create -f manifests/concourse-postgresql-svc.yaml
kubectl create -f manifests/concourse-postgresql-rc.yaml

kubectl create -f manifests/concourse-secrets.yaml
kubectl create -f manifests/concourse-web-svc.yaml
kubectl create -f manifests/concourse-web-rc.yaml
kubectl create -f manifests/concourse-worker-rc.yaml
