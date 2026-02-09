#!/bin/bash

# --- 1. AUTO-SUDO ---
# Automatically escalates to root so you never get permission denied
if [ "$EUID" -ne 0 ]; then 
  echo "[!] Escalating to root. Please enter password..."
  sudo "$0" "$@"
  exit $?
fi

# --- 2. COLORS ---
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' 

# --- 3. THE "FULL AUTO" DISCOVERY ---
# This function clears the list and pulls EVERY service currently on the system
refresh_services() {
    # We grab all service units, filter for just the names, and remove the '.service' extension
    SERVICES=($(systemctl list-units --type=service --all --no-legend | awk '{print $1}' | sed 's/\.service//g' | sort -u))
}

# --- 4. MAIN INTERFACE ---
while true; do
    refresh_services
    clear
    echo -e "${BLUE}==============================================================================${NC}"
    echo -e "${BLUE}                 FULL AUTOMATIC SERVICE CONTROL CENTER                        ${NC}"
    echo -e "${BLUE}==============================================================================${NC}"
    
    for i in "${!SERVICES[@]}"; do
        NAME="${SERVICES[$i]}"
        
        # Check status (Special logic for Bluetooth hardware)
        if [[ "$NAME" == "bluetooth" ]]; then
            if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
                STATUS="[ OFF ]"; COLOR=$RED
            else
                STATUS="[ ON  ]"; COLOR=$GREEN
            fi
        else
            if systemctl is-active --quiet "$NAME"; then
                STATUS="[ ON  ]"; COLOR=$GREEN
            else
                STATUS="[ OFF ]"; COLOR=$RED
            fi
        fi
        
        # STRAIGHT LINE ALIGNMENT (60 chars padding)
        printf "%2d) %-60s ${COLOR}%s${NC}\n" "$((i+1))" "$NAME" "$STATUS"
    done
    
    echo -e "${BLUE}------------------------------------------------------------------------------${NC}"
    echo " q) Quit"
    echo -e "${BLUE}==============================================================================${NC}"
    read -p "Select a service number to toggle: " CHOICE

    if [[ "$CHOICE" == "q" ]]; then break; fi

    # --- 5. TOGGLE LOGIC ---
    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "${#SERVICES[@]}" ]; then
        TARGET=${SERVICES[$((CHOICE-1))]}
        
        if [[ "$TARGET" == "bluetooth" ]]; then
            if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
                echo -e "${GREEN}>>> Powering ON Bluetooth...${NC}"
                rfkill unblock bluetooth; sleep 0.5; systemctl start bluetooth
            else
                echo -e "${RED}>>> Powering OFF Bluetooth...${NC}"
                systemctl stop bluetooth; rfkill block bluetooth
            fi
        else
            if systemctl is-active --quiet "$TARGET"; then
                echo -e "${RED}>>> Stopping $TARGET...${NC}"
                systemctl stop "$TARGET"
            else
                echo -e "${GREEN}>>> Starting $TARGET...${NC}"
                systemctl start "$TARGET"
            fi
        fi
        sleep 1
    else
        echo -e "${RED}[!] Invalid selection.${NC}"; sleep 1
    fi
done
