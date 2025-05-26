# 使用固定 Digest 的 Ubuntu 22.04 镜像
FROM ubuntu:latest

#
# 元信息
LABEL maintainer="karenxindongle@126.com"
LABEL description="A Ubuntu 22.04 dev image with SSH, FTP, Python 3.11, CUDA 12.6, Miniconda, and PyTorch Env"

# 避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 设置工作目录
WORKDIR /root

# FTP 被动模式 IP（可运行时覆盖）
ENV PASV_ADDRESS=127.0.0.1

# 安装常用工具 + SSH/FTP
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        wget \
        curl \
        git \
        vim \
        nano \
        unzip \
        software-properties-common \
        ca-certificates \
        gnupg \
        lsb-release \
        openssh-server \
        vsftpd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 配置 SSH
RUN mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 配置 FTP（支持被动模式）
RUN sed -i 's/anonymous_enable=NO/anonymous_enable=YES/' /etc/vsftpd.conf && \
    sed -i 's/#local_enable=YES/local_enable=YES/' /etc/vsftpd.conf && \
    sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf && \
    echo "pasv_enable=YES" >> /etc/vsftpd.conf && \
    echo "pasv_min_port=40000" >> /etc/vsftpd.conf && \
    echo "pasv_max_port=40010" >> /etc/vsftpd.conf && \
    echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd.conf

# 安装 CUDA 12.6
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    apt-get update && \
    apt-get install -y cuda-toolkit-12-6 && \
    rm -rf /var/lib/apt/lists/* cuda-keyring_1.1-1_all.deb

# 安装 Python 3.11 并设置为默认
# 安装 Python 3.11 并设置为默认（不使用 deadsnakes PPA，使用官方源码构建）
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    libsqlite3-dev \
    libbz2-dev \
    liblzma-dev \
    tk-dev \
    uuid-dev \
    curl && \
    wget https://www.python.org/ftp/python/3.11.8/Python-3.11.8.tgz && \
    tar -xzf Python-3.11.8.tgz && \
    cd Python-3.11.8 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    ln -sf /usr/local/bin/python3.11 /usr/bin/python && \
    ln -sf /usr/local/bin/python3.11 /usr/bin/python3 && \
    python3 --version && \
    cd .. && rm -rf Python-3.11.8 Python-3.11.8.tgz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# 安装 Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/miniconda3 && \
    rm miniconda.sh

# 设置 Conda 环境变量
ENV PATH="/opt/miniconda3/bin:${PATH}"

# 创建 Conda 虚拟环境
RUN conda create -y -n devenv python=3.11

# 拷贝并安装 requirements.txt
COPY requirements.txt /tmp/requirements.txt
RUN /opt/miniconda3/envs/devenv/bin/python -m pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -rf /tmp/requirements.txt && \
    conda clean -afy

# 自动进入环境
RUN echo "source /opt/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate devenv" >> ~/.bashrc

# 启动脚本
RUN echo '#!/bin/bash\n\
service ssh start\n\
service vsftpd start\n\
tail -f /dev/null' > /start.sh && \
    chmod +x /start.sh

# 暴露端口（SSH + FTP + 被动端口）
EXPOSE 20 21 22 40000-40010

# 设置默认启动命令
CMD ["/start.sh"]
