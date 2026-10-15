#!/bin/bash

# Move directly to the script directory
cd "$(dirname "$0")"

# Visual Style Setup (ANSI Color Codes)
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
CLEAR_LINE='\033[K'

# Dynamic Progress Bar Function
show_progress() {
    local percent=$1
    local msg=$2
    local width=30
    local completed=$((percent * width / 100))
    local remaining=$((width - completed))
    
    # Choose color based on progress phase
    local bar_color=$CYAN
    if [ "$percent" -eq 100 ]; then
        bar_color=$GREEN
    fi
    
    # Build visual blocks
    local filled_bar=""
    local empty_bar=""
    for ((i=0; i<completed; i++)); do filled_bar="${filled_bar}█"; done
    for ((i=0; i<remaining; i++)); do empty_bar="${empty_bar}░"; done
    
    # Print clean colored output line
    printf "\r${bar_color}[%s%s] %d%%${NC} ➔ %s${CLEAR_LINE}" "$filled_bar" "$empty_bar" "$percent" "$msg"
}

# Clear terminal screen for a premium look
clear
echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}             AUTOMATED REPO DEPLOYMENT            ${NC}"
echo -e "${BLUE}==================================================${NC}\n"

# ─────────────────────────────────────────────────────────────
# PHASE 1: Indexing materials
# ─────────────────────────────────────────────────────────────
show_progress 15 "Scanning workspace changes..."
sleep 0.4
git add .
show_progress 35 "All changes staged."
sleep 0.4

# ─────────────────────────────────────────────────────────────
# PHASE 2: Git Commit Generation
# ─────────────────────────────────────────────────────────────
show_progress 55 "Generating commit package..."

# Date formatted as Day Month(Letters) Year - Hour:Minute (e.g., 15 Oct 2026 - 15:30)
CURRENT_DATE=$(date "+%d %b %Y - %H:%M")
COMMIT_MSG="Auto Sync: $CURRENT_DATE"

# Run git commit silently
git commit -m "$COMMIT_MSG" > /dev/null 2>&1
show_progress 75 "Commit package sealed."
sleep 0.4

# ─────────────────────────────────────────────────────────────
# PHASE 3: GitHub Deployment
# ─────────────────────────────────────────────────────────────
show_progress 90 "Opening upstream tunnel to GitHub..."
git push > /dev/null 2>&1

# Network failure check
if [ $? -ne 0 ]; then
    printf "\n\n${RED}❌ [ERROR] Deployment failed.${NC}\n"
    echo -e "${YELLOW}Please check your network connection or GitHub permissions.${NC}"
    read -p "Press [Enter] to dismiss..."
    exit 1
fi

# Success completion state
show_progress 100 "Cloud deployment completed!"
echo -e "\n\n${GREEN}🚀 Done! Repository is now fully up to date.${NC}\n"

# Keep context window visible
sleep 3
