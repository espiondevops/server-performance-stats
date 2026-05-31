#!/usr/bin/env bash

# ==============================================================================
# Script Name: server-stats.sh
# Description: Analyzes and displays core Linux server performance metrics.
# ==============================================================================

# Ensure script is running with safe bash settings
set -euo pipefail

# Text Formatting Constants
readonly RESET='\033[0m'
readonly BOLD='\033[1m'
readonly GREEN='\033[32m'
readonly CYAN='\033[36m'
readonly YELLOW='\033[33m'

print_header() {
  local title
  title="$1"
  printf "\n${CYAN}=== ${title} ===${RESET}\n"
}

system_overview() {
  print_header 'System Overview'
  echo -e "${GREEN}OS Version: ${RESET}    $(hostnamectl | awk -F: '/Operating System/ {sub(/^ +/, "", $2); print $2}')"
  echo -e "${GREEN}Uptime: ${RESET}        $(uptime -p)"
  echo -e "${GREEN}Load Average: ${RESET}  $(uptime | awk -F 'load average: ' '{print $2}')"
  echo -e "${GREEN}Logged in User: ${RESET}$(uptime | awk -F, '{sub(/ +/, "", $2); print $2}')"
}

cpu_usage() {
  print_header 'CPU Usage'
  top -bn1 | grep 'Cpu(s)' | awk -v g=$GREEN -v r=$RESET '{printf "%sCPU Usage: %s%.2f%%\n", g, r, ($2 + $4)}'
}

get_memory_usage() {
  print_header 'Memory Allocation'
  free --mega | awk -v g="$GREEN" -v r="$RESET" '/Mem:/ {printf "%sUsed Mem:%s %iMB/%iMB %.2f%%\n", g, r, $3, $2, ($3 / $2) * 100}'
  free --mega | awk -v g="$GREEN" -v r="$RESET" '/Swap:/ {printf "%sUsed Swap:%s %iMB/%iMB %.2f%%\n", g, r, $3, $2, ($3 / $2) * 100}'
}

get_disk_usage() {
  print_header 'Disk Space'
  df -h | awk -v g="$GREEN" -v r="$RESET" '$NF == "/" {printf "%sUsed Space: %s%s (%s)\n",g, r, $3, $5}'
  df -h | awk -v g="$GREEN" -v r="$RESET" '$NF == "/" {printf "%sFree Space: %s\n",g, r $4}'
}

get_top_processes() {
  print_header 'Top Resource Consuming  Processes'
  by_CPU() {
  echo -e "\n${YELLOW}By CPU Usage:${RESET}"
  ps -eo pid,%cpu,command --sort=-%cpu | head -n 6
}

  by_disk_usage() {
  echo -e "\n${YELLOW}By Disk Usage:${RESET}"
  ps -eo  pid,%mem,command --sort=-%mem | head -n 6
}

  by_CPU
  by_disk_usage
}

get_failed_login() {
  print_header 'Security Alerts'
  sudo journalctl -u ssh -u systemd-logind | awk -v g=$GREEN -v r=$RESET '/failed/ {count++} END {printf "%sFailed Login Attempts: %s%s\n\n", g, r, count++}'
}

main() {
  system_overview
  cpu_usage
  get_memory_usage
  get_disk_usage
  get_top_processes
  get_failed_login
}

main "$@"
