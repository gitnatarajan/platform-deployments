#!/bin/sh

set -e

APP_ID="$1"
APP_ID=$(echo "$APP_ID" | tr '[:upper:]' '[:lower:]')

if [ -z "$APP_ID" ]; then
    echo "Usage: $0 <app_id>"
    exit 1
fi

# Change to Git repository
cd /git/platform-deployments || {
    echo "Git repository not found"
    exit 1
}

echo "====================================="
echo "Git Commit Script"
echo "APP_ID     : ${APP_ID}"
echo "Repository : $(pwd)"
echo "====================================="

# Verify application directory exists
if [ ! -d "applications/${APP_ID}" ]; then
    echo "ERROR: applications/${APP_ID} does not exist"
    exit 1
fi

echo "Staging files..."

# Stage only this application's manifests
git -c http.sslVerify=false add "applications/${APP_ID}"

# Check whether anything was staged
if git diff --cached --quiet; then
    echo "No changes detected."

    printf '{"app_id":"%s","status":"NO_CHANGES"}\n' "$APP_ID"
    exit 0
fi

echo "Creating commit..."

git -c http.sslVerify=false commit -m "Deploy ${APP_ID}"

echo "Pushing to GitHub..."

git -c http.sslVerify=false push origin main

echo "====================================="
echo "Successfully pushed ${APP_ID}"
echo "====================================="

printf '{"app_id":"%s","status":"GIT_PUSHED"}\n' "$APP_ID"