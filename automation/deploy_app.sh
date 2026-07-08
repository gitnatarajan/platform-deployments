#!/bin/sh

set -e
echo "ARG COUNT=$#"
echo "1=[$1]"
echo "2=[$2]"
echo "3=[$3]"
echo "4=[$4]"
echo "5=[$5]"
echo "6=[$6]"
echo "7=[$7]"
echo "8=[$8]"

REQUEST_ID="$1"
APP_NAME="$2"
IMAGE="$3"
PORT="$4"
NAMESPACE="$5"
REPLICAS="$6"
OWNER="$7"
SERVICE_ID="$8"

echo "========================================="
echo "Starting deployment workflow"
echo "Request ID : $REQUEST_ID"
echo "Application: $APP_NAME"
echo "========================================="

# # Move to repository
# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="/git/platform-deployments"
cd "$REPO_ROOT"

echo "Synchronizing Git repository..."

git -c http.sslVerify=false fetch origin
git -c http.sslVerify=false reset --hard origin/main
git -c http.sslVerify=false clean -fd

echo "Generating application manifests..."
echo "$REQUEST_ID $APP_NAME $IMAGE $PORT $NAMESPACE $REPLICAS $OWNER $SERVICE_ID" 

APP_ID=$(
sh automation/create_app.sh "$REQUEST_ID" "$APP_NAME" "$IMAGE" "$PORT" "$NAMESPACE" "$REPLICAS" "$OWNER" "$SERVICE_ID" | tail -1
)

echo "Generated APP_ID=$APP_ID"

echo "Committing manifests..."

sh automation/git_commit.sh "$APP_ID"

echo "Deployment workflow completed."

# Return APP_ID to n8n
echo "$APP_ID"