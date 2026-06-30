#!/bin/sh

set -e

APP_ID=$1

if [ -z "$APP_ID" ]; then
    echo "Usage: git_commit.sh <APP_ID>"
    exit 1
fi

REPO_ROOT=$(pwd)

echo "Committing ${APP_ID}"

git add applications/${APP_ID}

git commit -m "Deploy ${APP_ID}"

git -c http.sslVerify=false push origin main

echo "Git push completed"

printf '{"app_id":"%s","status":"GIT_PUSHED"}\n' "$APP_ID"