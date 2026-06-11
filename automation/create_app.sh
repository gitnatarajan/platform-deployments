#!/bin/bash

set -e

REQUEST_ID=$1
APP_NAME=$2 
IMAGE=$3
PORT=$4
APP_NAME=$(echo $APP_NAME | tr '[:upper:]' '[:lower:]')
# Generate APP ID

LAST=$(find applications -maxdepth 1 -type d -name "APP-*" | sort | tail -1)

if [ -z "$LAST" ]; then
    APP_ID="app-000001"
else
    NUM=$(basename "$LAST" | sed 's/APP-//')
    NEXT=$(printf "%06d" $((10#$NUM + 1)))
    APP_ID="app-$NEXT"
fi

echo "Generated APP ID: $APP_ID"

APP_DIR="applications/${APP_ID}"

mkdir -p "$APP_DIR"

echo "Creating application folder: $APP_DIR"

# Create basic metadata

cat > "${APP_DIR}/metadata.yaml" <<EOF
app_id: ${APP_ID}
request_id: ${REQUEST_ID}
application_name: ${APP_NAME}
image: ${IMAGE}
port: ${PORT}
status: active
EOF

echo "Application folder created successfully"

echo "APP_ID=${APP_ID}"
