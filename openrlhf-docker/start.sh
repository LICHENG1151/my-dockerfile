#!/bin/bash
set -e

#设置组可写
umask 002

# 可选：环境变量替换，处理默认用户等
if [[ -n "${NB_UID}" ]]; then
    usermod -u ${NB_UID} jovyan
fi

# 启动 Jupyter Lab
exec jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --NotebookApp.token='' \
  --NotebookApp.password='' \
  --NotebookApp.allow_origin='*' \
  --NotebookApp.base_url="${NB_PREFIX:-/}" \
  --NotebookApp.quit_button=False \
  --NotebookApp.allow_remote_access=True \
  --allow-root