#!/bin/bash
# ================================================================
#  HYDRA TERMUX — Auto-Record Terminal Demo
#  Usage: bash record_demo.sh
#  Requires: asciinema, agg (or svg-term-cli)
# ================================================================

GREEN='\033[32m'  CYAN='\033[36m'  ORANGE='\033[33m'
WHITE='\033[37m'  RED='\033[31m'   RESET='\033[0m'
BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_CAST="$SCRIPT_DIR/tunnel_demo.cast"
OUTPUT_GIF="$SCRIPT_DIR/tunnel_demo.gif"
OUTPUT_SVG="$SCRIPT_DIR/tunnel_demo.svg"

print_step() { echo -e "${GREEN}[+]${CYAN} $1${RESET}"; }
print_ok()   { echo -e "${GREEN}✔  $1${RESET}"; }
print_err()  { echo -e "${RED}[!] $1${RESET}"; }

# ── Check dependencies ──────────────────────────────────────────────
check_deps() {
    echo -e "\n${BOLD}${GREEN}Checking dependencies...${RESET}\n"
    for dep in asciinema; do
        if ! command -v "$dep" &>/dev/null; then
            print_err "$dep not found. Installing..."
            if   command -v pkg     &>/dev/null; then pkg install asciinema -y
            elif command -v apt     &>/dev/null; then sudo apt install asciinema -y
            elif command -v pip3    &>/dev/null; then pip3 install asciinema
            else print_err "Please install asciinema manually: https://asciinema.org/docs/installation"; exit 1
            fi
        else
            print_ok "$dep found"
        fi
    done

    # Check for GIF converter
    GIF_METHOD=""
    if command -v agg &>/dev/null; then
        GIF_METHOD="agg"; print_ok "agg found (will generate GIF)"
    elif command -v svg-term &>/dev/null; then
        GIF_METHOD="svg-term"; print_ok "svg-term found (will generate SVG)"
    else
        echo -e "${ORANGE}[!] agg/svg-term not found — recording .cast file only${RESET}"
        echo -e "${CYAN}    Install agg : https://github.com/asciinema/agg${RESET}"
        echo -e "${CYAN}    Install svg-term : npm install -g svg-term-cli${RESET}"
    fi
}

# ── The demo script that will be recorded ─────────────────────────
run_demo() {
    clear
    sleep 0.3

    # ── ASCII intro animation ──
    local lines=(
        "${GREEN} ████████╗██╗   ██╗███╗  ██╗███╗  ██╗███████╗██╗     "
        "${GREEN} ╚══██╔══╝██║   ██║████╗ ██║████╗ ██║██╔════╝██║     "
        "${GREEN}    ██║   ██║   ██║██╔██╗██║██╔██╗██║█████╗  ██║     "
        "${GREEN}    ██║   ██║   ██║██║╚████║██║╚████║██╔══╝  ██║     "
        "${GREEN}    ██║   ╚██████╔╝██║ ╚███║██║ ╚███║███████╗███████╗"
        "${GREEN}    ╚═╝    ╚═════╝ ╚═╝  ╚══╝╚═╝  ╚══╝╚══════╝╚══════╝"
    )
    for line in "${lines[@]}"; do
        echo -e "$line"; sleep 0.1
    done
    echo
    echo -e "${CYAN} CODED BY  HYDRA TERMUX  v1.0.0${WHITE}"
    echo -e "${GREEN} ──────────────────────────────────────────────"
    echo
    sleep 0.4

    # ── Progress bar ──
    echo -ne " ${CYAN}Loading"
    for i in 1 2 3; do echo -ne "${GREEN}."; sleep 0.25; done
    echo
    echo -ne " ${WHITE}["
    for i in $(seq 1 25); do printf "${GREEN}█"; sleep 0.05; done
    echo -e "${WHITE}]  ${GREEN}Done!"
    sleep 0.2

    # ── Spinner tasks ──
    local tasks=("Checking system" "Loading modules" "Setting up engine" "Ready")
    local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    for task in "${tasks[@]}"; do
        for s in "${spin[@]}" "${spin[@]}"; do
            printf "\r ${GREEN}%s${CYAN}  %s...   " "$s" "$task"; sleep 0.07
        done
        printf "\r ${GREEN}✔ ${WHITE}%-36s${GREEN}OK\n" "$task"; sleep 0.1
    done
    echo
    echo -e " ${GREEN}✔  TUNNEL READY — HYDRA TERMUX"
    sleep 0.8

    # ── Menu ──
    clear
    echo -e "${GREEN}"
    for line in "${lines[@]}"; do echo -e "$line"; done
    echo -e "${CYAN} CODED BY  HYDRA TERMUX  v1.0.0${WHITE}"
    echo -e "${GREEN} ──────────────────────────────────────────────${WHITE}"
    echo
    echo -e " ${WHITE}Host : ${CYAN}127.0.0.1   ${WHITE}Port : ${CYAN}8080"
    echo
    echo -e " ${RED}[${WHITE}1${RED}]${ORANGE} Start Cloudflared Tunnel"
    echo -e " ${RED}[${WHITE}2${RED}]${ORANGE} Change Host / Port"
    echo -e " ${RED}[${WHITE}0${RED}]${ORANGE} Exit"
    echo
    echo -ne " ${RED}[-]${GREEN} Select: ${CYAN}"
    sleep 1.0; echo -n "1"; sleep 0.5; echo

    # ── Tunnel starting ──
    echo
    echo -e " ${GREEN}[+]${CYAN} Starting tunnel on ${WHITE}http://127.0.0.1:8080${WHITE}"
    echo
    local spin2=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') si=0
    for i in $(seq 1 15); do
        printf "\r ${GREEN}%s${ORANGE}  Waiting for tunnel URL...  ${DIM}(%ds)${WHITE}" "${spin2[$si]}" "$i"
        si=$(( (si+1) % 10 )); sleep 0.5
    done
    echo
    echo -e "\n ${GREEN}✔  Tunnel is live!\n"
    sleep 0.4

    # ── URL output ──
    echo -e " ${GREEN}──────────────────────────────────────────────"
    echo -e " ${WHITE}  YOUR TUNNEL LINKS"
    echo -e " ${GREEN}──────────────────────────────────────────────"
    echo
    echo -e " ${WHITE}[1] Direct URL"
    echo -e "     ${CYAN}https://abc123-def456.trycloudflare.com"
    echo
    echo -e " ${GREEN}──────────────────────────────────────────────"
    echo -e " ${ORANGE}[*] Local  : ${WHITE}http://127.0.0.1:8080"
    echo -e " ${ORANGE}[*] Public : ${CYAN}https://abc123-def456.trycloudflare.com"
    echo -e " ${GREEN}──────────────────────────────────────────────"
    echo -e " ${ORANGE}[*] Press ${WHITE}Ctrl+C${ORANGE} to stop."
    echo
    sleep 3
}
export -f run_demo

# ── Main ──────────────────────────────────────────────────────────
echo -e "\n${BOLD}${GREEN}"
echo " ██╗  ██╗██╗   ██╗██████╗ ██████╗  █████╗ "
echo " ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗"
echo " ███████║ ╚████╔╝ ██║  ██║██████╔╝███████║"
echo " ██╔══██║  ╚██╔╝  ██║  ██║██╔══██╗██╔══██║"
echo " ██║  ██║   ██║   ██████╔╝██║  ██║██║  ██║"
echo " ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
echo -e "${CYAN} TUNNEL DEMO RECORDER${RESET}\n"

check_deps

print_step "Starting recording..."
echo -e "${ORANGE}[*] The demo will run automatically. Don't press any keys.${RESET}\n"
sleep 1

# Record with asciinema
COLUMNS=90 LINES=30 asciinema rec \
    --command "bash -c 'source \"$0\"; run_demo'" \
    --title "HYDRA TERMUX — Tunnel Tool Demo" \
    --idle-time-limit 2 \
    --overwrite \
    "$OUTPUT_CAST"

print_ok "Cast file saved: $OUTPUT_CAST"

# Convert to GIF if agg is available
if [[ "$GIF_METHOD" == "agg" ]]; then
    print_step "Converting to GIF with agg..."
    agg --theme monokai "$OUTPUT_CAST" "$OUTPUT_GIF" && print_ok "GIF saved: $OUTPUT_GIF"

elif [[ "$GIF_METHOD" == "svg-term" ]]; then
    print_step "Converting to SVG with svg-term..."
    svg-term --in "$OUTPUT_CAST" --out "$OUTPUT_SVG" --window && print_ok "SVG saved: $OUTPUT_SVG"
fi

echo
echo -e "${GREEN}══════════════════════════════════════════════${RESET}"
echo -e " ${WHITE}Files created:"
[[ -f "$OUTPUT_CAST" ]] && echo -e "   ${CYAN}$OUTPUT_CAST"
[[ -f "$OUTPUT_GIF"  ]] && echo -e "   ${GREEN}$OUTPUT_GIF"
[[ -f "$OUTPUT_SVG"  ]] && echo -e "   ${GREEN}$OUTPUT_SVG"
echo -e "${GREEN}══════════════════════════════════════════════${RESET}"
echo
echo -e " ${ORANGE}Upload the .cast to: ${CYAN}https://asciinema.org${RESET}"
echo -e " ${ORANGE}Embed in README with:${RESET}"
echo -e " ${WHITE}  [![asciicast](https://asciinema.org/a/YOUR_ID.svg)](https://asciinema.org/a/YOUR_ID)${RESET}"
echo
