#!/bin/sh

set -e

APP_ID=$1

if [ -z "$APP_ID" ]; then
    echo "Usage: $0 <APP_ID>"
    exit 1
fi

echo "Committing ${APP_ID}..."

# Stage application folder
git add "applications/${APP_ID}"

# Check whether anything is staged
if git diff --cached --quiet; then
    echo "No changes to commit."

    printf '{"app_id":"%s","status":"NO_CHANGES"}\n' "$APP_ID"
    exit 0
fi

# Commit
git commit -m "Deploy ${APP_ID}"

# Push
git push origin main

echo "Git push completed."

# Return JSON for n8n
printf '{"app_id":"%s","status":"GIT_PUSHED"}\n' "$APP_ID"