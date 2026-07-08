#!/bin/sh
set -e

REQUEST_ID="$1"
APP_NAME="$2"
IMAGE="$3"
PORT="$4"
NAMESPACE="$5"
REPLICAS="$6"
OWNER="$7"
SERVICE_ID="$8"

# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="/git/platform-deployments"

APP_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]'|sed 's/ //g')
NAMESPACE=$(echo "$NAMESPACE" | tr '[:upper:]' '[:lower:]')

# Generate APP ID
REQ_NUM=$(echo "$REQUEST_ID" | sed 's/^REQ-//')

# Last 7 digits of request id
SHORT_REQ=$(echo "$REQ_NUM" | tail -c 8)
APP_ID="${APP_NAME}-${SHORT_REQ}"
APP_DIR="${REPO_ROOT}/applications/${APP_ID}"
echo "Generating application directory: ${APP_DIR}" >&2

mkdir -p "${APP_DIR}"
# deployment.yaml
sed -e "s|{{APP_ID}}|${APP_ID}|g" -e "s|{{IMAGE}}|${IMAGE}|g" -e "s|{{PORT}}|${PORT}|g" -e "s|{{NAMESPACE}}|${NAMESPACE}|g" -e "s|{{REPLICAS}}|${REPLICAS}|g" \
"${REPO_ROOT}/templates/k8s/deployment.tpl" > "${APP_DIR}/deployment.yaml"

# service.yaml
sed -e "s|{{APP_ID}}|${APP_ID}|g" -e "s|{{PORT}}|${PORT}|g" -e "s|{{NAMESPACE}}|${NAMESPACE}|g" "${REPO_ROOT}/templates/k8s/service.tpl" > "${APP_DIR}/service.yaml"

# ingress.yaml
sed -e "s|{{APP_ID}}|${APP_ID}|g" -e "s|{{NAMESPACE}}|${NAMESPACE}|g" "${REPO_ROOT}/templates/k8s/ingress.tpl" > "${APP_DIR}/ingress.yaml"

# namespace.yaml
sed -e "s|{{NAMESPACE}}|${NAMESPACE}|g" "${REPO_ROOT}/templates/k8s/namespace.tpl" > "${APP_DIR}/namespace.yaml"

# kustomization.yaml
cp "${REPO_ROOT}/templates/k8s/kustomization.tpl" "${APP_DIR}/kustomization.yaml"

# metadata.yaml
cat > "${APP_DIR}/metadata.yaml" <<EOF
request_id: ${REQUEST_ID}
app_id: ${APP_ID}
application_name: ${APP_NAME}
namespace: ${NAMESPACE}
image: ${IMAGE}
replicas: ${REPLICAS}
port: ${PORT}
owner: ${OWNER}
service_id: ${SERVICE_ID}
status: CREATED
created_at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

echo "Application manifests created successfully." >&2


# Return APP_ID
echo "${APP_ID}"