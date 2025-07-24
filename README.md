> 💡 本页为中文版本 | [🌐 Switch to English Version](./README.en.md))

# 🚀 基于 Ubuntu 22.04 的开发环境镜像（含 Python 3.11、CUDA 12.6、Conda、SSH、FTP）

一个开箱即用的开发者友好型 Docker 镜像，基于 Ubuntu 22.04，内置：

* 🔧 系统工具（gcc、vim、curl、git 等）
* 🐍 Python 3.11（源码编译）
* 🧪 Miniconda，自动激活名为 `devenv` 的环境
* ⚡ CUDA Toolkit 12.6（使用 NVIDIA 官方仓库安装）
* 🔐 SSH 服务器（启用 root 登录）
* 📁 FTP 服务器（vsftpd，支持被动模式）
* 🚀 面向 AI、机器学习、Web3、后端开发等 Python 场景设计

---

## 📦 镜像信息

| 特性        | 详情                                        |
| --------- | ----------------------------------------- |
| 基础镜像      | `ubuntu:latest`（22.04）                    |
| Python 版本 | 3.11.8（源码编译）                              |
| Conda 版本  | 最新 Miniconda                              |
| CUDA 版本   | 12.6                                      |
| SSH       | 已启用，root 登录，密码：`password`                 |
| FTP       | 已启用，被动端口范围：`40000-40010`                  |
| 开发环境      | Conda 环境 `devenv`，自动安装 `requirements.txt` |

---

## 🛠 构建镜像

若你希望在本地构建此镜像：

```bash
docker build -t ubuntu2204_python311_cuda126 .
```
或者直接拉取我在构建好的镜像：
```bash
docker pull 3klxi/ckl-dl-images:ubuntu2204_python311_cuda126_torch26
```

---

## 🚀 运行容器

### 🔧 基础交互模式（命令行）

```bash
docker run -it ubuntu2204_python311_cuda126
```

### 🔐 启用 SSH 和 FTP（后台模式）

```bash
docker run -d \
  --name dev-env \
  -p 2222:22 \
  -p 21:21 -p 20:20 \
  -p 40000-40010:40000-40010 \
  ubuntu2204_python311_cuda126
```

然后你可以：

* SSH 登录：`ssh root@localhost -p 2222`（密码：`password`）
* FTP 连接：使用端口 `21`，用户名：`root`，密码：`password`

---

## 🧪 Conda 环境说明

容器内预置名为 `devenv` 的 Conda 环境。

```bash
conda activate devenv
```

容器登录时会自动激活该环境。

若你在构建镜像前准备了 `requirements.txt`，它将被自动安装至该环境中。

---

## 🌐 FTP 被动模式

支持 FTP 被动连接，配置如下：

* 端口范围：`40000-40010`
* 外部 IP：可通过环境变量 `PASV_ADDRESS` 设置（默认：`127.0.0.1`）

---

## 🧙‍♂️ 启动脚本

容器通过以下脚本启动：

```bash
/start.sh
```

该脚本会：

* 启动 SSH 服务
* 启动 FTP 服务
* 通过 `tail -f /dev/null` 保持容器持续运行

你也可以自定义启动命令（CMD）。

---

## 📂 自定义 Python 包依赖

在构建镜像前，在项目根目录下更新 `requirements.txt`。

---

## 🧱 可选的持久化挂载

挂载本地工作目录到容器中：

```bash
docker run -it -v $(pwd):/root/workspace ubuntu2204_python311_cuda126
```

---

## 💬 维护者

**[karenxindongle@126.com](mailto:karenxindongle@126.com)**

> 欢迎 fork 与交流！

---
