<div align="center">

<!-- HEADER BANNER -->
<img src="./assets/tunnel_banner.jpg" width="100%"/>

<br/>

<!-- BADGES ROW 1 -->
[![Version](https://img.shields.io/badge/version-1.0.0-00ff41?style=for-the-badge&logo=git&logoColor=white)](https://github.com/HYDRA-TERMUX/Tunnel)
[![Shell](https://img.shields.io/badge/shell-bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Termux%20%7C%20Linux-black?style=for-the-badge&logo=android&logoColor=00ff41)](https://termux.dev)
[![Cloudflare](https://img.shields.io/badge/powered%20by-Cloudflare-F48120?style=for-the-badge&logo=cloudflare&logoColor=white)](https://cloudflare.com)

<!-- BADGES ROW 2 -->
[![Stars](https://img.shields.io/github/stars/hydratermux/tunnel?style=for-the-badge&logo=github&color=00ff41&labelColor=0d0d0d)](https://github.com/HYDRA-TERMUX/Tunnel/stargazers)
[![Forks](https://img.shields.io/github/forks/hydratermux/tunnel?style=for-the-badge&logo=github&color=00bfff&labelColor=0d0d0d)](https://github.com/HYDRA-TERMUX/Tunnel/network/members)
[![License](https://img.shields.io/badge/license-MIT-red?style=for-the-badge&logo=opensourceinitiative&logoColor=white)](LICENSE)
[![YouTube](https://img.shields.io/badge/YouTube-HYDRA%20TERMUX-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtube.com/@hydratermux)

<br/>

```
 ████████╗██╗   ██╗███╗  ██╗███╗  ██╗███████╗██╗     
 ╚══██╔══╝██║   ██║████╗ ██║████╗ ██║██╔════╝██║     
    ██║   ██║   ██║██╔██╗██║██╔██╗██║█████╗  ██║     
    ██║   ██║   ██║██║╚████║██║╚████║██╔══╝  ██║     
    ██║   ╚██████╔╝██║ ╚███║██║ ╚███║███████╗███████╗
    ╚═╝    ╚═════╝ ╚═╝  ╚══╝╚═╝  ╚══╝╚══════╝╚══════╝
         CODED BY HYDRA TERMUX  •  v1.0.0
```

**Instantly expose your localhost to the internet using Cloudflare Tunnels — no account, no config, no port forwarding required.**

[🚀 Quick Start](#-quick-start) • [📺 Video Demo](#-video-demo) • [✨ Features](#-features) • [📸 Screenshots](#-screenshots) • [🛠 Installation](#-installation) • [📋 Usage](#-usage)

</div>

---

## 📺 Video Demo

<div align="center">

[![HYDRA TERMUX Tunnel Demo](https://img.youtube.com/vi/ZNbokMose27cywy2/maxresdefault.jpg)](https://youtube.com/@hydratermux?si=ZNbokMose27cywy2)

> 🎬 **Click the thumbnail above** to watch the full demo on YouTube  
> 🔔 **Subscribe** to HYDRA TERMUX for more Termux & hacking tools

</div>

---

## 📸 Screenshots

<div align="center">

### 🎬 Animated Demo

![HYDRA TERMUX Tunnel Demo](./assets/tunnel_demo.gif)

> *Full boot sequence → menu → live tunnel URL — generated automatically*

> 📌 **Pro tip:** Replace `tunnel_demo.gif` with a real recording using the included `record_demo.sh` script for a 1:1 authentic demo.

</div>

---

## ✨ Features

<div align="center">

| Feature | Description |
|---|---|
| 🌐 **Zero Config Tunneling** | Expose `localhost` to a public HTTPS URL instantly via Cloudflare |
| 🎭 **URL Masking** | @-Trick masking to disguise your tunnel URL with a custom domain preview |
| 🤖 **Auto Dependency Install** | Detects and installs `curl` & `unzip` via `pkg`, `apt`, `pacman`, or `dnf` |
| 📦 **Smart Cloudflared Installer** | Auto-detects CPU architecture (`arm64`, `armv7`, `x86_64`, `i386`) and downloads the right binary |
| ⚡ **Animated Boot Sequence** | Stylish ASCII art intro with progress bar and spinner animation |
| 🎛️ **Interactive Menu** | Clean terminal UI to start tunnel or change host/port on the fly |
| 🔄 **Multi-Platform Support** | Works on Termux, Ubuntu, Debian, Arch, Fedora, and most Linux distros |
| 🛡️ **Safe Signal Handling** | Gracefully handles `Ctrl+C` and cleans up background processes |

</div>

---

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/HYDRA-TERMUX/Tunnel.git

# 2. Navigate to the folder
cd tunnel

# 3. Give execute permission
chmod +x tunnel.sh

# 4. Run the tool
bash tunnel.sh
```

> ✅ That's it! The script handles everything else automatically.

---

## 🛠 Installation

### 📱 Termux (Android)

```bash
# Update packages
pkg update -y && pkg upgrade -y

# Install git
pkg install git -y

# Clone and run
git clone https://github.com/HYDRA-TERMUX/Tunnel.git
cd tunnel
bash tunnel.sh
```

### 🐧 Debian / Ubuntu / Kali Linux

```bash
sudo apt update && sudo apt install git curl unzip -y
git clone https://github.com/HYDRA-TERMUX/Tunnel.git
cd tunnel
bash tunnel.sh
```

### 🏴 Arch Linux / BlackArch

```bash
sudo pacman -S git curl unzip --noconfirm
git clone https://github.com/HYDRA-TERMUX/Tunnel.git
cd tunnel
bash tunnel.sh
```

### 🎩 Fedora / RedHat

```bash
sudo dnf install git curl unzip -y
git clone https://github.com/HYDRA-TERMUX/Tunnel.git
cd tunnel
bash tunnel.sh
```

---

## 📋 Usage

### Starting a Tunnel

```
 ════════════════════════════════════════
   TUNNEL  •  HYDRA TERMUX  •  v1.0.0
 ════════════════════════════════════════

 Host : 127.0.0.1   Port : 8080

 [1] Start Cloudflared Tunnel
 [2] Change Host / Port
 [0] Exit

 [-] Select: _
```

1. Run `bash tunnel.sh`
2. Select **[1]** to start the tunnel
3. Wait for the public URL to appear
4. *(Optional)* Add a custom mask domain when prompted

### Changing Host & Port

Select **[2]** from the main menu to set a custom host/port:

```bash
# Default values
HOST = 127.0.0.1
PORT = 8080

# Example: expose a Flask app on port 5000
HOST = 127.0.0.1
PORT = 5000
```

### URL Masking (@-Trick)

When your tunnel is live, the script will ask:

```
[?] Add @-Trick URL masking? [y/N]:
```

If you answer **y**, enter a domain like `https://google.com`.  
Your masked link will look like:
```
https://google.com@abc123.trycloudflare.com
```
> ⚠️ The preview shows `google.com` but the real URL still appears in the browser address bar.

---

## 🗂 File Structure

```
tunnel/
├── tunnel.sh           # Main script
├── .server/
│   ├── cloudflared     # Auto-downloaded Cloudflare binary
│   └── .cld.log        # Tunnel process log (auto-created)
└── README.md
```

---

## ⚙️ How It Works

```
┌─────────────────────────────────────────────────────────┐
│                    HOW TUNNEL WORKS                     │
├──────────────┬──────────────────┬───────────────────────┤
│   Your App   │  tunnel.sh runs  │  Cloudflare Network   │
│              │  cloudflared     │                       │
│  localhost   │ ──────────────►  │  trycloudflare.com    │
│  :8080       │   Secure Tunnel  │  Public HTTPS URL     │
└──────────────┴──────────────────┴───────────────────────┘
```

1. **Script downloads** `cloudflared` binary for your CPU architecture
2. **Cloudflared creates** an outbound-only encrypted tunnel to Cloudflare's edge
3. **Cloudflare assigns** a random public `*.trycloudflare.com` subdomain
4. **Traffic flows**: Internet → Cloudflare Edge → Tunnel → Your localhost

> 🔒 **No inbound ports opened.** No router config. Works behind NAT, CGNAT, and firewalls.

---

## 📦 Requirements

| Requirement | Details |
|---|---|
| **OS** | Linux, Android (Termux), WSL2 |
| **Shell** | Bash 4.0+ |
| **Network** | Internet connection |
| **Packages** | `curl`, `unzip` *(auto-installed if missing)* |
| **Binary** | `cloudflared` *(auto-downloaded)* |

---

## 🐛 Troubleshooting

<details>
<summary><b>❌ Tunnel URL not found after 60s</b></summary>

```bash
# Delete the cached binary and retry
rm -f .server/cloudflared
bash tunnel.sh
```

Check your internet connection and ensure port outbound 443 is not blocked.
</details>

<details>
<summary><b>❌ Permission denied</b></summary>

```bash
chmod +x tunnel.sh
bash tunnel.sh
```
</details>

<details>
<summary><b>❌ cloudflared binary fails on Termux</b></summary>

The script will automatically try installing via `pkg install cloudflared`. If that also fails, install manually:

```bash
pkg install cloudflared -y
```
</details>

<details>
<summary><b>❌ Script exits immediately</b></summary>

Make sure you're running with `bash`, not `sh`:
```bash
bash tunnel.sh   ✅
sh tunnel.sh     ❌
```
</details>

---

## 📺 Subscribe to HYDRA TERMUX

<div align="center">

[![Subscribe](https://img.shields.io/badge/▶%20SUBSCRIBE-HYDRA%20TERMUX-FF0000?style=for-the-badge&logo=youtube&logoColor=white&labelColor=282828)](https://youtube.com/@hydratermux?si=ZNbokMose27cywy2)

This tool is **100% free** — but it runs on your support! 🙏  
If this saved you time, please **Subscribe** and hit the 🔔 bell for more tools.

</div>

---

## 📜 License

```
MIT License — Free to use, modify, and distribute.
Credits to HYDRA TERMUX must be maintained.
```

---

## ⭐ Star History

<a href="https://star-history.com/#HYDRA-TERMUX/Tunnel&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=HYDRA-TERMUX/Tunnel&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=HYDRA-TERMUX/Tunnel&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=HYDRA-TERMUX/Tunnel&type=Date" />
 </picture>
</a>

---

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:008f11,100:00ff41&height=120&section=footer&text=HYDRA%20TERMUX&fontSize=28&fontColor=ffffff&fontAlignY=65" width="100%"/>

**Made with 💚 by [HYDRA TERMUX](https://youtube.com/@hydratermux)**

</div>
