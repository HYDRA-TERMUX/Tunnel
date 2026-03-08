#!/bin/bash
__version__="1.0.0"

## DEFAULT HOST & PORT
HOST='127.0.0.1'
PORT='8080'

## ANSI colors
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')"  BLACK="$(printf '\033[30m')"
GREENBG="$(printf '\033[42m')"  RESETBG="$(printf '\e[0m\n')"
BOLD="$(printf '\033[1m')"   DIM="$(printf '\033[2m')"

BASE_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
mkdir -p "$BASE_DIR/.server"
rm -f "$BASE_DIR/.server/.cld.log"

## ── SIGNALS ────────────────────────────────────────────────────────
trap 'printf "\n\n%s\n\n" "${RED}[!] Interrupted."; reset_color; exit 0' SIGINT SIGTERM
reset_color() { tput sgr0; tput op; }

## ── KILL OLD PROCESSES ─────────────────────────────────────────────
kill_pid() {
	pidof cloudflared > /dev/null 2>&1 && killall cloudflared > /dev/null 2>&1
}

## ── TUNNEL INTRO ANIMATION ─────────────────────────────────────────
tunnel_intro() {
	clear
	sleep 0.2

	## TUNNEL ASCII — reveal line by line
	local lines=(
		"${GREEN} ████████╗██╗   ██╗███╗  ██╗███╗  ██╗███████╗██╗     "
		"${GREEN} ╚══██╔══╝██║   ██║████╗ ██║████╗ ██║██╔════╝██║     "
		"${GREEN}    ██║   ██║   ██║██╔██╗██║██╔██╗██║█████╗  ██║     "
		"${GREEN}    ██║   ██║   ██║██║╚████║██║╚████║██╔══╝  ██║     "
		"${GREEN}    ██║   ╚██████╔╝██║ ╚███║██║ ╚███║███████╗███████╗"
		"${GREEN}    ╚═╝    ╚═════╝ ╚═╝  ╚══╝╚═╝  ╚══╝╚══════╝╚══════╝"
	)
	for line in "${lines[@]}"; do
		echo -e "$line"
		sleep 0.08
	done

	echo
	echo -e "${CYAN} CODED BY  HYDRA TERMUX  v${__version__}${WHITE}"
	echo -e "${GREEN} ──────────────────────────────────────────────"
	echo
	sleep 0.4

	## Progress bar
	echo -ne " ${CYAN}Loading"
	for i in 1 2 3; do echo -ne "${GREEN}."; sleep 0.25; done
	echo

	echo -ne " ${WHITE}["
	for i in $(seq 1 25); do
		printf "${GREEN}█"
		sleep 0.04
	done
	echo -e "${WHITE}]  ${GREEN}Done!"
	sleep 0.2

	## Spinner tasks
	local tasks=("Checking system" "Loading modules" "Setting up engine" "Ready")
	local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
	for task in "${tasks[@]}"; do
		for s in "${spin[@]}" "${spin[@]}"; do
			printf "\r ${GREEN}%s${CYAN}  %s...   " "$s" "$task"
			sleep 0.06
		done
		printf "\r ${GREEN}✔ ${WHITE}%-36s${GREEN}OK\n" "$task"
		sleep 0.1
	done

	echo
	echo -e " ${GREEN}✔  TUNNEL READY — HYDRA TERMUX"
	echo
	sleep 0.5
}

## ── SPINNER HELPER ──────────────────────────────────────────────────
anim_task() {
	local msg="$1"
	local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
	for s in "${spin[@]}" "${spin[@]}"; do
		printf "\r ${GREEN}%s${CYAN}  %s...   " "$s" "$msg"
		sleep 0.06
	done
	printf "\r ${GREEN}✔ ${WHITE}%-38s\n" "$msg"
}

## ── DEPENDENCIES ───────────────────────────────────────────────────
dependencies() {
	echo -e "\n ${GREEN}[+]${CYAN} Checking packages...${WHITE}"
	for pkg in curl unzip; do
		command -v "$pkg" &>/dev/null && continue
		anim_task "Installing $pkg"
		if   command -v pkg     &>/dev/null; then pkg install "$pkg" -y     > /dev/null 2>&1
		elif command -v apt     &>/dev/null; then sudo apt install "$pkg" -y > /dev/null 2>&1
		elif command -v apt-get &>/dev/null; then sudo apt-get install "$pkg" -y > /dev/null 2>&1
		elif command -v pacman  &>/dev/null; then sudo pacman -S "$pkg" --noconfirm > /dev/null 2>&1
		elif command -v dnf     &>/dev/null; then sudo dnf -y install "$pkg" > /dev/null 2>&1
		else echo -e "\n ${RED}[!] Install curl and unzip manually."; reset_color; exit 1
		fi
		echo -e " ${GREEN}✔ ${WHITE}$pkg installed"
	done
	echo -e " ${GREEN}✔ ${WHITE}All packages ready"
}

## ── DOWNLOAD HELPER ────────────────────────────────────────────────
download() {
	local url="$1" output="$2" file
	file=$(basename "$url")
	rm -rf "$file" "$BASE_DIR/.server/$output"
	curl --silent --insecure --fail --retry-connrefused \
		--retry 3 --retry-delay 2 --location --output "$file" "$url"
	if [[ -e "$file" ]]; then
		local ext="${file##*.}"
		if   [[ "$ext" == "zip" ]]; then unzip -qq "$file" > /dev/null 2>&1; mv -f "$output" "$BASE_DIR/.server/$output" 2>/dev/null
		elif [[ "$ext" == "tgz" ]]; then tar -zxf "$file"  > /dev/null 2>&1; mv -f "$output" "$BASE_DIR/.server/$output" 2>/dev/null
		else mv -f "$file" "$BASE_DIR/.server/$output" 2>/dev/null
		fi
		chmod +x "$BASE_DIR/.server/$output"
		rm -rf "$file"
	else
		echo -e "\n ${RED}[!] Download failed: $output"; reset_color; exit 1
	fi
}

## ── INSTALL CLOUDFLARED ────────────────────────────────────────────
install_cloudflared() {
	if [[ -e "$BASE_DIR/.server/cloudflared" ]]; then
		if "$BASE_DIR/.server/cloudflared" version > /dev/null 2>&1; then
			echo -e " ${GREEN}✔ ${WHITE}Cloudflared already installed\n"; return
		else
			echo -e " ${ORANGE}[!] Bad binary, redownloading...${WHITE}"
			rm -f "$BASE_DIR/.server/cloudflared"
		fi
	fi

	local arch; arch=$(uname -m)
	local cpu_abi=""; command -v getprop &>/dev/null && cpu_abi=$(getprop ro.product.cpu.abi 2>/dev/null)
	echo -e " ${GREEN}[+]${CYAN} Arch: ${ORANGE}$arch  ${CYAN}ABI: ${ORANGE}${cpu_abi:-unknown}${WHITE}"

	local url=""
	if   [[ "$arch" == "aarch64" || "$cpu_abi" == "arm64-v8a" ]]; then url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64'
	elif [[ "$arch" == *armv7*   || "$cpu_abi" == "armeabi-v7a" ]]; then url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm'
	elif [[ "$arch" == "x86_64" ]];                                 then url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64'
	elif [[ "$arch" == i*86 ]];                                     then url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386'
	else
		echo -e " ${ORANGE}[!] Unknown arch, defaulting to arm64${WHITE}"
		url='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64'
	fi

	anim_task "Downloading Cloudflared"
	download "$url" cloudflared

	if "$BASE_DIR/.server/cloudflared" version > /dev/null 2>&1; then
		echo -e " ${GREEN}✔ ${WHITE}Cloudflared installed successfully\n"
	else
		echo -e " ${ORANGE}[!] Binary failed, trying pkg install...${WHITE}"
		if command -v pkg &>/dev/null; then
			pkg install cloudflared -y > /dev/null 2>&1
			local sys_cf; sys_cf=$(command -v cloudflared 2>/dev/null)
			if [[ -n "$sys_cf" ]]; then
				cp "$sys_cf" "$BASE_DIR/.server/cloudflared"
				chmod +x "$BASE_DIR/.server/cloudflared"
				echo -e " ${GREEN}✔ ${WHITE}Installed via pkg!\n"
			else
				echo -e " ${RED}[!] All install methods failed."; reset_color; exit 1
			fi
		else
			echo -e " ${RED}[!] Cannot install cloudflared."; reset_color; exit 1
		fi
	fi
}

## ── BANNER (compact for menu/results) ──────────────────────────────
banner() {
	echo -e "${GREEN}"
	echo -e " ████████╗██╗   ██╗███╗  ██╗███╗  ██╗███████╗██╗     "
	echo -e " ╚══██╔══╝██║   ██║████╗ ██║████╗ ██║██╔════╝██║     "
	echo -e "    ██║   ██║   ██║██╔██╗██║██╔██╗██║█████╗  ██║     "
	echo -e "    ██║   ██║   ██║██║╚████║██║╚████║██╔══╝  ██║     "
	echo -e "    ██║   ╚██████╔╝██║ ╚███║██║ ╚███║███████╗███████╗"
	echo -e "    ╚═╝    ╚═════╝ ╚═╝  ╚══╝╚═╝  ╚══╝╚══════╝╚══════╝"
	echo -e "${CYAN} CODED BY  HYDRA TERMUX  v${__version__}${WHITE}"
	echo -e "${GREEN} ──────────────────────────────────────────────${WHITE}"
	echo
}

msg_exit() {
	clear
	echo -e "\n ${GREEN}Goodbye! See you soon.${WHITE}\n"
	reset_color; exit 0
}

## ── OPTIONAL @-TRICK MASK ──────────────────────────────────────────
custom_mask() {
	echo
	read -n1 -p " ${RED}[?]${ORANGE} Add @-Trick URL masking? ${GREEN}[${CYAN}y${GREEN}/${CYAN}N${GREEN}]: ${ORANGE}" m; echo
	mask_domain=""
	if [[ "${m,,}" == "y" ]]; then
		echo -e "\n ${GREEN}[+]${CYAN} Enter domain for link preview"
		echo -e " ${CYAN}    e.g: ${WHITE}https://hydratermux.blogspot.com\n"
		read -p " ${WHITE}==> ${ORANGE}" mask_url
		mask_url="${mask_url%/}"; mask_url="${mask_url// /}"
		[[ "$mask_url" != http* ]] && mask_url="https://$mask_url"
		mask_domain="${mask_url#*//}"
		echo -e "\n ${GREEN}[+]${CYAN} Mask domain: ${GREEN}$mask_domain"
	fi
}

## ── DISPLAY URLS (no box, clean lines) ─────────────────────────────
show_urls() {
	local tunnel_url="$1"
	local raw="${tunnel_url#https://}"

	clear; banner

	echo -e " ${GREEN}──────────────────────────────────────────────"
	echo -e " ${WHITE}  YOUR TUNNEL LINKS"
	echo -e " ${GREEN}──────────────────────────────────────────────"
	echo
	echo -e " ${WHITE}[1] Direct URL"
	echo -e "     ${CYAN}$tunnel_url"
	echo

	if [[ -n "$mask_domain" ]]; then
		local atrick="https://${mask_domain}@${raw}"
		echo -e " ${ORANGE}── URL MASKING ────────────────────────────────"
		echo
		echo -e " ${WHITE}[2] @-Trick Link"
		echo -e "     ${ORANGE}$atrick"
		echo
		echo -e "     ${CYAN}^ Preview shows : ${WHITE}$mask_domain"
		echo -e "     ${CYAN}  Real URL shown in browser bar"
		echo
	fi

	echo -e " ${GREEN}──────────────────────────────────────────────"
	echo -e " ${ORANGE}[*] Local  : ${WHITE}http://$HOST:$PORT"
	echo -e " ${ORANGE}[*] Public : ${CYAN}$tunnel_url"
	echo -e " ${GREEN}──────────────────────────────────────────────"
	echo -e " ${ORANGE}[*] Press ${WHITE}Ctrl+C${ORANGE} to stop."
	echo
}

## ── START TUNNEL ───────────────────────────────────────────────────
start_cloudflared() {
	rm -f "$BASE_DIR/.server/.cld.log"

	echo -e "\n ${GREEN}[+]${CYAN} Starting tunnel on ${WHITE}http://$HOST:$PORT${WHITE}\n"

	local cf_bin="$BASE_DIR/.server/cloudflared"
	command -v cloudflared &>/dev/null && cf_bin=$(command -v cloudflared)

	"$cf_bin" tunnel \
		--url "$HOST:$PORT" \
		--no-autoupdate \
		> "$BASE_DIR/.server/.cld.log" 2>&1 &

	local url="" waited=0
	local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') si=0
	while [[ -z "$url" && $waited -lt 60 ]]; do
		printf "\r ${GREEN}%s${ORANGE}  Waiting for tunnel URL...  ${DIM}(%ds)${WHITE}" "${spin[$si]}" "$waited"
		si=$(( (si+1) % ${#spin[@]} ))
		sleep 1; waited=$((waited+1))
		url=$(grep -oE 'https://[a-zA-Z0-9-]+\.trycloudflare\.com' \
			"$BASE_DIR/.server/.cld.log" 2>/dev/null | head -1)
		if [[ -z "$url" ]]; then
			local raw2; raw2=$(grep -oE '[a-zA-Z0-9-]+\.trycloudflare\.com' \
				"$BASE_DIR/.server/.cld.log" 2>/dev/null | head -1)
			[[ -n "$raw2" ]] && url="https://$raw2"
		fi
	done
	echo

	if [[ -z "$url" ]]; then
		echo -e "\n ${RED}[!] Tunnel URL not found."
		echo -e " ${ORANGE}[*] Log:\n ${WHITE}──────────────────────────────"
		cat "$BASE_DIR/.server/.cld.log" 2>/dev/null || echo " (empty)"
		echo -e " ${WHITE}──────────────────────────────"
		echo -e "\n ${ORANGE}Try: ${CYAN}rm -f .server/cloudflared && bash tunnel.sh"
		reset_color; exit 1
	fi

	echo -e "\n ${GREEN}✔  Tunnel is live!\n"
	custom_mask
	show_urls "$url"
	wait
}

## ── MAIN MENU ──────────────────────────────────────────────────────
main_menu() {
	clear; banner
	echo -e " ${WHITE}Host : ${CYAN}$HOST   ${WHITE}Port : ${CYAN}$PORT"
	echo
	echo -e " ${RED}[${WHITE}1${RED}]${ORANGE} Start Cloudflared Tunnel"
	echo -e " ${RED}[${WHITE}2${RED}]${ORANGE} Change Host / Port"
	echo -e " ${RED}[${WHITE}0${RED}]${ORANGE} Exit"
	echo
	read -p " ${RED}[-]${GREEN} Select: ${BLUE}"
	case $REPLY in
		1)    start_cloudflared ;;
		2)
			read -p " ${RED}[-]${ORANGE} Host [${HOST}]: ${WHITE}" h
			[[ -n "$h" ]] && HOST="$h"
			read -p " ${RED}[-]${ORANGE} Port [${PORT}]: ${WHITE}" p
			[[ -n "$p" ]] && PORT="$p"
			main_menu ;;
		0|00) msg_exit ;;
		*)    echo -ne "\n ${RED}[!] Invalid option."; sleep 1; main_menu ;;
	esac
}

## ── YOUTUBE SUBSCRIPTION GATE ──────────────────────────────────────
YT_URL="https://youtube.com/@hydratermux?si=ZNbokMose27cywy2"

open_youtube() {
	## Try every available method to open the YouTube channel
	if command -v termux-open-url &>/dev/null; then
		termux-open-url "$YT_URL" 2>/dev/null &
	elif command -v xdg-open &>/dev/null; then
		xdg-open "$YT_URL" 2>/dev/null &
	elif command -v am &>/dev/null; then
		## Android activity manager — works on rooted / ADB shells
		am start -a android.intent.action.VIEW -d "$YT_URL" 2>/dev/null &
	elif command -v sensible-browser &>/dev/null; then
		sensible-browser "$YT_URL" 2>/dev/null &
	elif command -v open &>/dev/null; then
		open "$YT_URL" 2>/dev/null &
	fi
}

check_subscription() {
	clear
	echo -e "${GREEN}"
	echo -e " ████████╗██╗   ██╗███╗  ██╗███╗  ██╗███████╗██╗     "
	echo -e " ╚══██╔══╝██║   ██║████╗ ██║████╗ ██║██╔════╝██║     "
	echo -e "    ██║   ██║   ██║██╔██╗██║██╔██╗██║█████╗  ██║     "
	echo -e "    ██║   ██║   ██║██║╚████║██║╚████║██╔══╝  ██║     "
	echo -e "    ██║   ╚██████╔╝██║ ╚███║██║ ╚███║███████╗███████╗"
	echo -e "    ╚═╝    ╚═════╝ ╚═╝  ╚══╝╚═╝  ╚══╝╚══════╝╚══════╝"
	echo -e "${CYAN} CODED BY  HYDRA TERMUX  v${__version__}${WHITE}"
	echo -e "${GREEN} ──────────────────────────────────────────────${WHITE}"
	echo

	echo -e " ${RED}╔══════════════════════════════════════════════╗"
	echo -e " ${RED}║                                              ║"
	echo -e " ${RED}║   ${ORANGE}⚠  SUBSCRIPTION REQUIRED TO CONTINUE  ${RED}║"
	echo -e " ${RED}║                                              ║"
	echo -e " ${RED}╚══════════════════════════════════════════════╝"
	echo
	echo -e " ${WHITE} This tool is ${GREEN}FREE${WHITE} — but needs your support! 🙏"
	echo
	echo -e " ${GREEN} ──────────────────────────────────────────────"
	echo -e " ${CYAN}  📺  Channel  : ${WHITE}HYDRA TERMUX"
	echo -e " ${CYAN}  🔗  Link     : ${WHITE}$YT_URL"
	echo -e " ${GREEN} ──────────────────────────────────────────────"
	echo

	## Auto-open YouTube channel immediately
	echo -e " ${ORANGE} ⚡ Opening YouTube channel automatically...${WHITE}"
	open_youtube

	## Countdown so user sees it opening
	local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') si=0
	for i in $(seq 5 -1 1); do
		printf "\r ${GREEN}%s${CYAN}  YouTube opening — please SUBSCRIBE now... ${ORANGE}(%ds) ${WHITE}" \
			"${spin[$si]}" "$i"
		si=$(( (si+1) % ${#spin[@]} ))
		sleep 1
	done
	echo
	echo

	echo -e " ${ORANGE} STEPS:"
	echo -e " ${WHITE}  1. ${GREEN}YouTube is now open${WHITE} in your browser"
	echo -e " ${WHITE}  2. Tap the ${RED}[ SUBSCRIBE ]${WHITE} button"
	echo -e " ${WHITE}  3. Tap the ${ORANGE}🔔 bell${WHITE} icon for notifications"
	echo -e " ${WHITE}  4. Come back here and press ${GREEN}y"
	echo
	echo -e " ${GREEN} ──────────────────────────────────────────────"
	echo

	while true; do
		read -n1 -p " ${RED}[?]${ORANGE} Did you subscribe? ${GREEN}[${CYAN}y${GREEN}] Yes  [${CYAN}n${GREEN}] No : ${WHITE}" ans
		echo
		case "${ans,,}" in
			y)
				echo
				echo -e " ${GREEN}✔  Subscribed — Thank you! Welcome to HYDRA TERMUX 🎉"
				echo -e " ${CYAN}   Loading tool..."
				echo
				sleep 1
				break
				;;
			n)
				echo
				echo -e " ${RED}✘  Not subscribed — tool is locked."
				echo
				echo -e " ${ORANGE}  ⚡ Re-opening YouTube channel...${WHITE}"
				open_youtube
				echo
				## Countdown again
				for i in $(seq 5 -1 1); do
					printf "\r ${ORANGE}  Subscribe now and press y to continue... (%ds) ${WHITE}" "$i"
					sleep 1
				done
				echo
				echo
				;;
			*)
				echo -e " ${RED}  [!] Press  y  or  n  only"
				;;
		esac
	done
}

## ── ENTRY POINT ────────────────────────────────────────────────────
kill_pid
check_subscription
tunnel_intro
dependencies
install_cloudflared
main_menu
