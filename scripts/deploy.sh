#!/bin/bash
APP=$1
IMAGE=$2
PORT=$3

APP_DIR=apps/services/$APP

mkdir -p $APP_DIR
sed "s/{{APP_NAME}}/$APP/g; s/{{IMAGE}}/$IMAGE/g; s/{{PORT}}/$PORT/g" apps/templates/deployment.tpl > $APP_DIR/deployment.yaml
sed "s/{{APP_NAME}}/$APP/g; s/{{PORT}}/$PORT/g" apps/templates/service.tpl > $APP_DIR/service.yaml
sed "s/{{APP_NAME}}/$APP/g" apps/templates/ingress.tpl > $APP_DIR/ingress.yaml

git add .
git commit -m "deploy $APP"
git push