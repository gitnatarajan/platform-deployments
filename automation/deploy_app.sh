#!/bin/bash

set -e

APP=$1
APP=$(echo "$APP" | tr '[:upper:]' '[:lower:]')
IMAGE=$2
PORT=$3
NAMESPACE=$4
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Kubernetes namespace must be lowercase
NAMESPACE=$(echo "$NAMESPACE" | tr '[:upper:]' '[:lower:]')

APP_DIR="${REPO_ROOT}/applications/${APP}"

mkdir -p "$APP_DIR"

sed "
s/{{APP_NAME}}/$APP/g;
s#{{IMAGE}}#$IMAGE#g;
s/{{PORT}}/$PORT/g;
s/{{NAMESPACE}}/$NAMESPACE/g
" "${REPO_ROOT}/templates/k8s/deployment.tpl" \
> "${APP_DIR}/deployment.yaml"

sed "
s/{{APP_NAME}}/$APP/g;
s/{{PORT}}/$PORT/g;
s/{{NAMESPACE}}/$NAMESPACE/g
" "${REPO_ROOT}/templates/k8s/service.tpl" \
> "${APP_DIR}/service.yaml"

sed "
s/{{APP_NAME}}/$APP/g;
s/{{NAMESPACE}}/$NAMESPACE/g
" "${REPO_ROOT}/templates/k8s/ingress.tpl" \
> "${APP_DIR}/ingress.yaml"

sed "
s/{{NAMESPACE}}/$NAMESPACE/g
" "${REPO_ROOT}/templates/k8s/namespace.tpl" \
> "${APP_DIR}/namespace.yaml"

cd "${REPO_ROOT}"

git add .

git commit -m "deploy ${APP}" || true

git push origin main

echo "Deployment manifests created for ${APP}"
echo "Namespace: ${NAMESPACE}"