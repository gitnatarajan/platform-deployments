#!/bin/bash

set -e

APP_ID=$1
REQUEST_ID=$2
APP_NAME=$3
IMAGE=$4
PORT=$5
REQUESTED_BY=$6

APP_DIR="applications/${APP_ID}"

mkdir -p "${APP_DIR}"

NAMESPACE=$(echo ${APP_ID} | tr '[:upper:]' '[:lower:]')

for FILE in deployment service ingress namespace metadata kustomization
do

  cp templates/kubernetes/${FILE}.tpl \
     ${APP_DIR}/${FILE}.yaml

  sed -i "s/{{APP_ID}}/${APP_ID}/g" \
      ${APP_DIR}/${FILE}.yaml

  sed -i "s/{{REQUEST_ID}}/${REQUEST_ID}/g" \
      ${APP_DIR}/${FILE}.yaml

  sed -i "s/{{APP_NAME}}/${APP_NAME}/g" \
      ${APP_DIR}/${FILE}.yaml

  sed -i "s#{{IMAGE}}#${IMAGE}#g" \
      ${APP_DIR}/${FILE}.yaml

  sed -i "s/{{PORT}}/${PORT}/g" \
      ${APP_DIR}/${FILE}.yaml

  sed -i "s/{{REQUESTED_BY}}/${REQUESTED_BY}/g" \
      ${APP_DIR}/${FILE}.yaml

  sed -i "s/{{NAMESPACE}}/${NAMESPACE}/g" \
      ${APP_DIR}/${FILE}.yaml

  sed -i "s/{{REPLICAS}}/1/g" \
      ${APP_DIR}/${FILE}.yaml

done

echo "Generated manifests for ${APP_ID}"