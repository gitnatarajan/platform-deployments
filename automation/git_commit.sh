#!/bin/sh

set -e

APP_ID=$1

if [ -z "$APP_ID" ]; then
    echo "Usage: $0 <APP_ID>"
    exit 1
fi

echo "Committing ${APP_ID}..."

# Always sync with remote first
git pull --rebase origin main

# Stage files
git add "applications/${APP_ID}"

# Nothing to commit?
if git diff --cached --quiet; then
    echo "No changes to commit."
    printf '{"app_id":"%s","status":"NO_CHANGES"}\n' "$APP_ID"
    exit 0
fi

# Commit
git commit -m "Deploy ${APP_ID}"

# Push
git push origin main

printf '{"app_id":"%s","status":"GIT_PUSHED"}\n' "$APP_ID"