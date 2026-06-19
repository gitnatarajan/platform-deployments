#!/bin/bash

set -e

APP_ID=$1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

cd "${REPO_ROOT}"

git add applications/${APP_ID}

git commit -m "Create ${APP_ID}" || true

git push origin main

echo "Committed ${APP_ID}"