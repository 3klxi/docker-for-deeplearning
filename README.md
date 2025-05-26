# 🚀 Ubuntu 22.04 Dev Environment with Python 3.11, CUDA 12.6, Conda, SSH & FTP

A complete developer-ready Docker image based on Ubuntu 22.04, with:

- 🔧 System tools (gcc, vim, curl, git, etc.)
- 🐍 Python 3.11 (built from source)
- 🧪 Miniconda with an auto-activated `devenv`
- ⚡ CUDA Toolkit 12.6 (NVIDIA official repo)
- 🔐 SSH server (root login enabled)
- 📁 FTP server (vsftpd, passive mode supported)
- 🚀 Designed for AI, ML, Web3, or backend Python-based development

---

## 📦 Image Info

| Feature         | Details                                         |
|----------------|--------------------------------------------------|
| Base Image      | `ubuntu:latest` (22.04)                         |
| Python Version  | 3.11.8 (compiled from source)                   |
| Conda Version   | Latest Miniconda                                |
| CUDA Version    | 12.6                                            |
| SSH             | Enabled, root login, password: `password`       |
| FTP             | Enabled, passive mode `40000-40010`             |
| Dev Env         | Conda env `devenv` with `requirements.txt`      |

---

## 🛠 Build Instructions

If you'd like to build the image locally:

```bash
docker build -t ubuntu2204_python311_cuda126 .
```

---

## 🚀 Run the Container

### 🔧 Basic (interactive shell)

```bash
docker run -it ubuntu2204_python311_cuda126
```

### 🔐 With SSH & FTP (background mode)

```bash
docker run -d \
  --name dev-env \
  -p 2222:22 \
  -p 21:21 -p 20:20 \
  -p 40000-40010:40000-40010 \
  ubuntu2204_python311_cuda126
```

You can then:

- SSH: `ssh root@localhost -p 2222` (password: `password`)
- FTP: connect to port `21` (user: `root`, password: `password`)

---

## 🧪 Conda Environment

The container includes a pre-created conda env called `devenv`.

```bash
conda activate devenv
```

On container login, the environment is automatically activated.

If you have a `requirements.txt`, it will be pre-installed into the env during build.

---

## 🌐 FTP Passive Mode

Supports passive FTP connections via:

- Ports: `40000-40010`
- External IP: configured via `PASV_ADDRESS` env variable (default: `127.0.0.1`)

---

## 🧙‍♂️ Start Script

Container starts via:

```bash
/start.sh
```

This script:

- Starts SSH
- Starts FTP
- Keeps container running via `tail -f /dev/null`

You can override the CMD if needed.

---

## 📂 Customize Requirements

Update your `requirements.txt` in the project root before build.

---

## 🧱 Persistent Volumes (optional)

Mount your local workspace:

```bash
docker run -it -v $(pwd):/root/workspace ubuntu2204_python311_cuda126
```

---

## 💬 Maintainer

**karenxindongle@126.com**

---

如果你要发布到 Docker Hub 或 GitHub 项目，这个 README 是完全 ready-to-go 的 ✅  
你还想我帮你补一份 `.devcontainer.json` 吗？让你 VSCode 一键连接容器直接开发？😎