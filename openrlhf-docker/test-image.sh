#!/bin/bash
set -e

IMAGE=$1

echo "🎯 正在测试镜像: $IMAGE"

docker run --rm --gpus all
$IMAGE python -c "import torch; assert torch.cuda.is_available(), 'CUDA 不可用'; print('✅ CUDA OK')"