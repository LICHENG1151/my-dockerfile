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

# ------------------- OpenRLHF 相关配置开始 -------------------

# 卸载容易冲突的包（官方推荐）
RUN pip uninstall -y xgboost transformer_engine flash_attn pynvml || true

# 安装 OpenRLHF（多种方式，任选其一，建议只用一种）

# 方式1：只装主包
# RUN pip install openrlhf

# 方式2：加 vLLM 支持（推荐，如需推理加速）
# RUN pip install openrlhf[vllm]

# 方式3：最新 vLLM
# RUN pip install openrlhf[vllm_latest]

# 方式4：vLLM + ring-flash-attn + Liger-Kernel
RUN pip install openrlhf[vllm,ring,liger]

# 方式5：源码最新版（可选，不建议和上面方式混用）
# RUN git clone https://github.com/OpenRLHF/OpenRLHF.git /workspace/OpenRLHF \
#     && pip install -e /workspace/OpenRLHF

# ------------------- OpenRLHF 相关配置结束 -------------------

# 拷贝并运行测试脚本
COPY test_cuda.py /workspace/test_cuda.py
RUN python /workspace/test_cuda.py

# 拷贝启动脚本
COPY start.sh /usr/local/bin/start.sh
RUN sed -i 's/\r$//' /usr/local/bin/start.sh \
 && chmod +x /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]