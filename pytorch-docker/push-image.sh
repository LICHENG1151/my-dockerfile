#!/bin/bash
set -e

if [ $# -lt 2 ]; then
  echo "用法: $0 <镜像名> <标签> [仓库地址]"
  exit 1
fi

IMAGE_NAME=$1
TAG=$2
REGISTRY=${3:-docker.io/your_dockerhub_username}

FULL_IMAGE="$REGISTRY/$IMAGE_NAME:$TAG"

docker tag $IMAGE_NAME:latest $FULL_IMAGE
docker push $FULL_IMAGE
echo "✅ 镜像已推送: $FULL_IMAGE"