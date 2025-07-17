# === 基础设置与 PyTorch 环境 ===
ARG BASE_IMAGE=nvidia/cuda:12.6.0-cudnn-devel-ubuntu22.04
ARG PYTORCH_INDEX=https://download.pytorch.org/whl/cu126
ARG PYTORCH_VERSION=2.6.0
ARG TORCHVISION_VERSION=0.21.0
ARG TORCHAUDIO_VERSION=2.6.0

FROM ${BASE_IMAGE}

ARG PYTORCH_INDEX
ARG PYTORCH_VERSION
ARG TORCHVISION_VERSION
ARG TORCHAUDIO_VERSION
ARG KUBECTL_VERSION=v1.32.5

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV PYTORCH_INDEX=${PYTORCH_INDEX}
ENV PYTORCH_VERSION=${PYTORCH_VERSION}
ENV TORCHVISION_VERSION=${TORCHVISION_VERSION}
ENV TORCHAUDIO_VERSION=${TORCHAUDIO_VERSION}

# === 更换APT源 & 安装系统依赖 ===
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-dev \
    git wget curl ca-certificates sudo \
    libjpeg-dev libpng-dev libgl1 tini tmux \
    libnss3 libxss1 libasound2 fonts-liberation libatk-bridge2.0-0 libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

# === 安装 kubectl ===
RUN curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# === 创建 jovyan 用户（Kubeflow Notebook 标准用户）===
ARG NB_USER=jovyan
ARG NB_UID=1000
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# === 添加 entrypoint 启动脚本 ===
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER $NB_USER
WORKDIR /home/$NB_USER

# === 安装 PyTorch + 常用 Python 包 ===
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        torch==$PYTORCH_VERSION \
        torchvision==$TORCHVISION_VERSION \
        torchaudio==$TORCHAUDIO_VERSION \
        --index-url $PYTORCH_INDEX && \
    pip install --no-cache-dir jupyter jupyterlab matplotlib scipy transformers tqdm

# === 安装 Code-Server ===
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN mkdir -p ~/.config/code-server && \
    echo 'bind-addr: 0.0.0.0:8888\n\
auth: none\n\
cert: false' > ~/.config/code-server/config.yaml

# === 安装vscode extension ===
RUN code-server --install-extension ms-python.python

# === 安装 OpenRLHF（按需）===
RUN pip uninstall -y xgboost transformer_engine flash_attn pynvml || true && \
    pip install openrlhf[vllm,ring,liger]

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["entrypoint.sh"]

EXPOSE 8888

