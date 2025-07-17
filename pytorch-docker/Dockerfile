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
ENV PYTORCH_INDEX=${PYTORCH_INDEX}
ENV PYTORCH_VERSION=${PYTORCH_VERSION}
ENV TORCHVISION_VERSION=${TORCHVISION_VERSION}
ENV TORCHAUDIO_VERSION=${TORCHAUDIO_VERSION}
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

WORKDIR /workspace

# 更换 Ubuntu 源为国内阿里云，以加速下载
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list

# 安装 Python 及系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-dev \
    git wget curl ca-certificates \
    libjpeg-dev libpng-dev libgl1 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

# 安装指定版本的 PyTorch 及组件
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        torch==$PYTORCH_VERSION \
        torchvision==$TORCHVISION_VERSION \
        torchaudio==$TORCHAUDIO_VERSION \
        --index-url $PYTORCH_INDEX

# 安装常用依赖
RUN pip install --no-cache-dir jupyter matplotlib scipy transformers tqdm

# 拷贝并运行测试脚本
COPY test_cuda.py /workspace/test_cuda.py
RUN python /workspace/test_cuda.py
# 拷贝启动脚本
COPY start.sh /usr/local/bin/start.sh
# 去掉 CRLF、并加执行权限
RUN sed -i 's/\r$//' /usr/local/bin/start.sh \
 && chmod +x /usr/local/bin/start.sh
# 使用 start.sh 作为容器的入口
ENTRYPOINT ["/usr/local/bin/start.sh"]