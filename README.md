# Server Performance Stats Utility

> **Project Challenge:** This script was built as part of the backend automation path. You can find the full project requirements and details on the official [Project Page URL](https://roadmap.sh/projects/server-stats).

A modular, lightweight Bash script to analyze and display core Linux server performance metrics, optimized to run seamlessly across Ubuntu environments.

## Features
- **Core Metrics:** Real-time Total CPU, Memory Allocation, and Root Disk Space usage.
- **Process Analysis:** Top 5 resource-consuming processes sorted dynamically by CPU and Memory load.
- **Stretch Goals Met:** System overview tracking (OS version, uptime, load average, active users) and a dedicated security alert tally for failed login attempts.

## Requirements
- Access to `journalctl` logs (user should belong to the `systemd-journal` group or have `sudo` access).

## Installation & Usage

1. Clone or download the script to your server.
2. Make the script executable:
   ```bash
   chmod +x server-stats.sh
