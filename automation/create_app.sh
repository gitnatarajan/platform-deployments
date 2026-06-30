#!/bin/sh

set -e

REQUEST_ID=$1
APP_NAME=$2
IMAGE=$3
PORT=$4
NAMESPACE=$5
REPLICAS=$6
OWNER=$7
SERVICE_ID=$8

# Find repo root
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(dirname "$SCRIPT_DIR")

APP_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')

LAST=$(find "${REPO_ROOT}/applications" -maxdepth 1 -type d -name "APP-*" | sort | tail -1)

if [ -z "$LAST" ]; then
    APP_ID="APP-000001"
else
    NUM=$(basename "$LAST" | sed 's/APP-//')
    NEXT=$(printf "%06d" $((10#$NUM + 1)))
    APP_ID="APP-$NEXT"
fi

echo "Generated APP ID: $APP_ID"

APP_DIR="${REPO_ROOT}/applications/${APP_ID}"

mkdir -p "$APP_DIR"

cat > "${APP_DIR}/metadata.yaml" <<EOF
app_id: ${APP_ID}
request_id: ${REQUEST_ID}
application_name: ${APP_NAME}
image: ${IMAGE}
port: ${PORT}
namespace: ${NAMESPACE}
replicas: ${REPLICAS}
owner: ${OWNER}
service_id: ${SERVICE_ID}
status: active
EOF

echo "Application folder created successfully"
echo "${APP_ID}"



# #!/bin/bash

# set -e

# REQUEST_ID=$1
# APP_NAME=$2
# IMAGE=$3
# PORT=$4
# NAMESPACE=$5
# REPLICAS=$6
# OWNER=$7
# SERVICE_ID=$8
# # Find repo root
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# APP_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')

# LAST=$(find "${REPO_ROOT}/applications" -maxdepth 1 -type d -name "APP-*" | sort | tail -1)

# if [ -z "$LAST" ]; then
#     APP_ID="APP-000001"
# else
#     NUM=$(basename "$LAST" | sed 's/APP-//')
#     NEXT=$(printf "%06d" $((10#$NUM + 1)))
#     APP_ID="APP-$NEXT"
# fi

# echo "Generated APP ID: $APP_ID"

# APP_DIR="${REPO_ROOT}/applications/${APP_ID}"

# mkdir -p "$APP_DIR"

# cat > "${APP_DIR}/metadata.yaml" <<EOF
# app_id: ${APP_ID}
# request_id: ${REQUEST_ID}
# application_name: ${APP_NAME}
# image: ${IMAGE}
# port: ${PORT}
# namespace: ${NAMESPACE}
# replicas: ${REPLICAS}
# owner: ${OWNER}
# service_id: ${SERVICE_ID}
# status: active
# EOF

# echo "Application folder created successfully"
# echo "${APP_ID}"