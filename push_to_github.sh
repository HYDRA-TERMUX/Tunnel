#!/bin/bash
# ================================================================
#  HYDRA TERMUX — One-Command GitHub Uploader
#  Run this script from inside the unzipped Tunnel/ folder
#  Usage: bash push_to_github.sh
# ================================================================

GREEN='\033[32m' CYAN='\033[36m' ORANGE='\033[33m'
WHITE='\033[37m' RED='\033[31m'  RESET='\033[0m' BOLD='\033[1m'

echo -e "\n${BOLD}${GREEN}"
echo " ████████╗██╗   ██╗███╗  ██╗███╗  ██╗███████╗██╗     "
echo " ╚══██╔══╝██║   ██║████╗ ██║████╗ ██║██╔════╝██║     "
echo "    ██║   ██║   ██║██╔██╗██║██╔██╗██║█████╗  ██║     "
echo "    ██║   ██║   ██║██║╚████║██║╚████║██╔══╝  ██║     "
echo "    ██║   ╚██████╔╝██║ ╚███║██║ ╚███║███████╗███████╗"
echo "    ╚═╝    ╚═════╝ ╚═╝  ╚══╝╚═╝  ╚══╝╚══════╝╚══════╝"
echo -e "${CYAN} GITHUB UPLOADER${RESET}\n"

REPO_URL="https://github.com/HYDRA-TERMUX/Tunnel.git"

# ── Check git ──────────────────────────────────────────────────────
if ! command -v git &>/dev/null; then
    echo -e "${RED}[!] git not found. Installing...${RESET}"
    if   command -v pkg     &>/dev/null; then pkg install git -y
    elif command -v apt     &>/dev/null; then sudo apt install git -y
    else echo -e "${RED}[!] Please install git manually.${RESET}"; exit 1
    fi
fi
echo -e "${GREEN}✔ ${WHITE}git found${RESET}"

# ── Git config (if not set) ────────────────────────────────────────
if [[ -z "$(git config --global user.name)" ]]; then
    read -p " ${CYAN}Enter your GitHub username: ${WHITE}" GH_USER
    git config --global user.name "$GH_USER"
fi
if [[ -z "$(git config --global user.email)" ]]; then
    read -p " ${CYAN}Enter your GitHub email: ${WHITE}" GH_EMAIL
    git config --global user.email "$GH_EMAIL"
fi

# ── Initialize and push ────────────────────────────────────────────
echo -e "\n${GREEN}[+]${CYAN} Initializing git repo...${RESET}"
git init
git add .
git status --short

echo -e "\n${GREEN}[+]${CYAN} Creating initial commit...${RESET}"
git commit -m "🚀 Initial release — HYDRA TERMUX Tunnel v1.0.0

- tunnel.sh: Cloudflare tunnel tool with animated boot sequence
- assets/banner.svg: Animated SVG banner
- assets/tunnel_demo.gif: Terminal demo GIF
- record_demo.sh: asciinema recording helper
- README.md: Full GitHub documentation
- LICENSE: MIT"

echo -e "\n${GREEN}[+]${CYAN} Setting remote to ${WHITE}$REPO_URL${RESET}"
git remote remove origin 2>/dev/null
git remote add origin "$REPO_URL"
git branch -M main

echo -e "\n${ORANGE}[*] Pushing to GitHub...${RESET}"
echo -e "${CYAN}    You may be prompted for your GitHub token (use a Personal Access Token)${RESET}\n"
git push -u origin main

if [[ $? -eq 0 ]]; then
    echo -e "\n${GREEN}══════════════════════════════════════════════${RESET}"
    echo -e " ${GREEN}✔  Successfully pushed to GitHub!${RESET}"
    echo -e " ${CYAN}   $REPO_URL${RESET}"
    echo -e "${GREEN}══════════════════════════════════════════════${RESET}\n"
else
    echo -e "\n${RED}[!] Push failed.${RESET}"
    echo -e "${ORANGE}    Make sure:${RESET}"
    echo -e "${WHITE}    1. The repo exists at: $REPO_URL"
    echo -e "    2. You have push access"
    echo -e "    3. Use a Personal Access Token as password"
    echo -e "       → https://github.com/settings/tokens/new${RESET}\n"
fi
