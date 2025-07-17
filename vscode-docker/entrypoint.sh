#!/bin/bash
set -eux

# 设置创建文件时的权限（group 可写）
umask 002

# 自动生成 kubeconfig 供 kubectl 使用
mkdir -p /home/jovyan/.kube
cat <<EOF > /home/jovyan/.kube/config
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    server: https://kubernetes.default.svc
  name: in-cluster
contexts:
- context:
    cluster: in-cluster
    namespace: $(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
    user: in-cluster-user
  name: in-cluster-context
current-context: in-cluster-context
users:
- name: in-cluster-user
  user:
    token: $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
EOF
chmod 600 /home/jovyan/.kube/config

# 启动服务：Jupyter 后台，Code-Server 前台
#jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser &
exec code-server --bind-addr 0.0.0.0:8888 --auth none

