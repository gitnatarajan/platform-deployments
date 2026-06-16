#!/bin/bash

set -e

APP_ID=$1
REQUEST_ID=$2
APP_NAME=$3
IMAGE=$4
PORT=$5
REQUESTED_BY=$6
NAMESPACE=$7
REPLICAS=${8:-1}
APPROVED_BY=${9:-pending}
ENV=${10:-dev}
CREATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
APP_DIR="applications/${APP_ID}"

mkdir -p "${APP_DIR}"

# Kubernetes namespace must be lowercase
NAMESPACE=$(echo "${NAMESPACE}" | tr '[:upper:]' '[:lower:]')

echo "Generating manifests for ${APP_ID}"
echo "Namespace: ${NAMESPACE}"

for FILE in deployment service ingress namespace metadata kustomization
do

  cp "../templates/k8s/${FILE}.tpl" \
     "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{APP_ID}}/${APP_ID}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{REQUEST_ID}}/${REQUEST_ID}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{APP_NAME}}/${APP_NAME}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s#{{IMAGE}}#${IMAGE}#g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{PORT}}/${PORT}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{REQUESTED_BY}}/${REQUESTED_BY}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{NAMESPACE}}/${NAMESPACE}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{REPLICAS}}/${REPLICAS}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{APPROVED_BY}}/${APPROVED_BY}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{ENV}}/${ENV}/g" \
      "${APP_DIR}/${FILE}.yaml"

  sed -i "s/{{CREATED_AT}}/${CREATED_AT}/g" \
      "${APP_DIR}/${FILE}.yaml"
done

echo "Generated manifests for ${APP_ID}"