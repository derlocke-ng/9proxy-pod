# 9proxy Podman/Docker Container

A containerized 9proxy CLI application with SSH access, built on Fedora.

## 🚀 Features

- **9proxy CLI**: Full-featured 9proxy client for Linux
- **SSH Access**: Secure remote access via SSH
- **Non-root User**: Runs with dedicated `user` account for security
## 📋 Prerequisites

- Podman or Docker installed on your system
- Network access to download the container image
- SSH client for remote access

## 🔧 Quick Start

### Option 1: Build Locally

```bash
# Clone the repository
git clone https://github.com/derlocke-ng/9proxy-pod.git
cd 9proxy-pod

# Build the container image
podman build -t 9proxy-pod .

# Run the container
podman run -d --privileged \
  -p 2222:22 \
  -p 60000-60009:60000-60009 \
  --name 9proxy-pod \
  9proxy-pod
```

### Option 2: Use Pre-built Image (if available)

```bash
# Pull from GitHub Container Registry
podman pull ghcr.io/derlocke-ng/9proxy-pod:latest

# Run the container
podman run -d --privileged \
  -p 2222:22 \
  -p 60000-60009:60000-60009 \
  --name 9proxy-pod \
  ghcr.io/derlocke-ng/9proxy-pod:latest
```

## 🔐 SSH Access

Connect to the container via SSH:

```bash
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null user@localhost -p 2222
```

**Default Credentials:**
- Username: `user`
- Password: `9proxy`

**⚠️ Security Note**: Change the default password in the Dockerfile before deploying to production!

## 📦 Using 9proxy

### 1. Connect to 9proxy pod

```bash
# SSH into the container first
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null user@localhost -p 2222
```

### 2. Sign In to Your 9proxy Account

**Option A: Interactive Login**
```bash
9proxy auth -s
```
Enter your username and password when prompted.

**Option B: Command Line Login**
```bash
9proxy auth -u derlocke-ng -p YOUR_PASSWORD
```

### 3. Get Available Commands

```bash
9proxy -h
```

**Common Commands:**
- `9proxy api` - API functions
- `9proxy auth` - Account authentication
- `9proxy port` - Port management
- `9proxy proxy` - Get proxy IPs (most important)
- `9proxy setting` - Configure 9proxy settings

### 4. Configure Auto Refresh Proxy

```bash
# Set maximum number of refreshes (-1 for unlimited)
9proxy setting -c -1

# Set refresh time after dead IP (in seconds)
9proxy setting -t 60

# Enable auto refresh
9proxy setting -r

# Disable auto refresh
9proxy setting -n
```

### 5. Sign Out

```bash
9proxy auth -l
```

## 🛠️ Container Management

### Start/Stop Container

```bash
# Stop the container
podman stop 9proxy-pod

# Start the container
podman start 9proxy-pod

# Restart the container
podman restart 9proxy-pod
```

### View Logs

```bash
# View container logs
podman logs 9proxy-pod

# Follow logs in real-time
podman logs -f 9proxy-pod
```

### Remove Container

```bash
# Stop and remove
podman stop 9proxy-pod
podman rm 9proxy-pod
```

## 🔧 Customization

### Change User Password

Edit the `Dockerfile` before building:

```dockerfile
RUN useradd -m -s /bin/bash user && \
    echo "user:YOUR_NEW_PASSWORD" | chpasswd
```

### Modify Port Range

Edit the `Dockerfile` to expose different ports:

```dockerfile
EXPOSE 22
EXPOSE YOUR_CUSTOM_PORT_RANGE
```

Then adjust the `podman run` command accordingly.

## 📚 Documentation

- [9proxy Installation Guide](https://docs.9proxy.com/getting-started/for-linux/linux-install-and-download)
- [Sign In to 9proxy Account](https://docs.9proxy.com/getting-started/for-linux/sign-in-to-9proxy-account)
- [Command References](https://docs.9proxy.com/getting-started/for-linux/command-references)
- [Auto Refresh Proxy](https://docs.9proxy.com/getting-started/for-linux/auto-refresh-proxy)

## 🐛 Troubleshooting

### SSH Connection Refused

Ensure the container is running and the port is correctly mapped:

```bash
podman ps | grep 9proxy-pod
```

## 📄 License

This project is provided as-is for educational and development purposes.

## 🙏 Credits

- [9proxy](https://9proxy.com/) - Proxy service provider
- Built with Podman/Docker and Fedora Linux
