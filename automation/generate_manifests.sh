#!/bin/sh

set -e

APP_ID=$1

if [ -z "$APP_ID" ]; then
    echo "Usage: $0 <APP_ID>"
    exit 1
fi

# Repository root (run this script from /git/platform-deployments)
REPO_ROOT=$(pwd)

APP_DIR="${REPO_ROOT}/applications/${APP_ID}"
METADATA="${APP_DIR}/metadata.yaml"

if [ ! -f "$METADATA" ]; then
    echo "Metadata file not found:"
    echo "$METADATA"
    exit 1
fi

# Read values from metadata.yaml
REQUEST_ID=$(grep '^request_id:' "$METADATA" | cut -d':' -f2- | xargs)
APP_NAME=$(grep '^application_name:' "$METADATA" | cut -d':' -f2- | xargs)
IMAGE=$(grep '^image:' "$METADATA" | cut -d':' -f2- | xargs)
PORT=$(grep '^port:' "$METADATA" | cut -d':' -f2- | xargs)
NAMESPACE=$(grep '^namespace:' "$METADATA" | cut -d':' -f2- | xargs)
REPLICAS=$(grep '^replicas:' "$METADATA" | cut -d':' -f2- | xargs)
REQUESTED_BY=$(grep '^owner:' "$METADATA" | cut -d':' -f2- | xargs)
SERVICE_ID=$(grep '^service_id:' "$METADATA" | cut -d':' -f2- | xargs)

# Optional values
APPROVED_BY=$(grep '^approved_by:' "$METADATA" | cut -d':' -f2- | xargs)
# ENV=$(grep '^environment:' "$METADATA" | cut -d':' -f2- | xargs)

[ -z "$APPROVED_BY" ] && APPROVED_BY="pending"
# [ -z "$ENV" ] && ENV="dev"

CREATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Kubernetes namespace must be lowercase
NAMESPACE=$(echo "$NAMESPACE" | tr '[:upper:]' '[:lower:]')

echo "Generating manifests for ${APP_ID}"
echo "Repository Root: ${REPO_ROOT}"

for FILE in deployment service ingress namespace metadata kustomization
do

    cp "${REPO_ROOT}/templates/k8s/${FILE}.tpl" \
       "${APP_DIR}/${FILE}.yaml"

    sed -i "s/{{APP_ID}}/${APP_ID}/g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s/{{REQUEST_ID}}/${REQUEST_ID}/g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s/{{APP_NAME}}/${APP_NAME}/g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s#{{IMAGE}}#${IMAGE}#g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s/{{PORT}}/${PORT}/g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s/{{REQUESTED_BY}}/${REQUESTED_BY}/g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s/{{NAMESPACE}}/${NAMESPACE}/g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s/{{REPLICAS}}/${REPLICAS}/g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s/{{APPROVED_BY}}/${APPROVED_BY}/g" "${APP_DIR}/${FILE}.yaml"
    # sed -i "s/{{ENV}}/${ENV}/g" "${APP_DIR}/${FILE}.yaml"
    sed -i "s/{{CREATED_AT}}/${CREATED_AT}/g" "${APP_DIR}/${FILE}.yaml"

done

echo ""
echo "Generated manifests successfully."
echo "Application ID : ${APP_ID}"
echo "Request ID     : ${REQUEST_ID}"
echo "Application    : ${APP_NAME}"
echo "Output Folder  : ${APP_DIR}"