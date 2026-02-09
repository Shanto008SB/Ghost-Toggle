#!/bin/bash

# --- 1. AUTO-SUDO ---
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

# --- 3. SERVICES & SCANNER ---
SERVICES=("bluetooth" "apache2" "NetworkManager" "ssh")

# Scan system for all other services
EXTRAS=$(ls /etc/systemd/system/ | grep "\.service$" | grep -v "@" | sed 's/\.service//g')
for srv in $EXTRAS; do
    if [[ ! " ${SERVICES[@]} " =~ " ${srv} " ]]; then
        SERVICES+=("$srv")
    fi
done

# --- 4. MAIN INTERFACE ---
while true; do
    clear
    echo -e "${BLUE}==============================================================================${NC}"
    echo -e "${BLUE}                    KALI LINUX SERVICE CONTROL CENTER                         ${NC}"
    echo -e "${BLUE}==============================================================================${NC}"
    
    for i in "${!SERVICES[@]}"; do
        NAME="${SERVICES[$i]}"
        
        if [[ "$NAME" == "bluetooth" ]]; then
            if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
                STATUS="[ OFF ]"
                COLOR=$RED
            else
                STATUS="[ ON  ]"
                COLOR=$GREEN
            fi
        else
            if systemctl is-active --quiet "$NAME"; then
                STATUS="[ ON  ]"
                COLOR=$GREEN
            else
                STATUS="[ OFF ]"
                COLOR=$RED
            fi
        fi
        
        # FIXED: Padding increased to 60 for perfect straight line alignment
        printf "%2d) %-60s ${COLOR}%s${NC}\n" "$((i+1))" "$NAME" "$STATUS"
    done
    
    echo -e "${BLUE}------------------------------------------------------------------------------${NC}"
    echo " q) Quit"
    echo -e "${BLUE}==============================================================================${NC}"
    read -p "Select a service number to toggle: " CHOICE

    if [[ "$CHOICE" == "q" ]]; then break; fi

    # --- 5. FIXED TOGGLE LOGIC ---
    # Fixed the typo: Changed ${CHOice} to ${#SERVICES[@]}
    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "${#SERVICES[@]}" ]; then
        TARGET=${SERVICES[$((CHOICE-1))]}
        
        if [[ "$TARGET" == "bluetooth" ]]; then
            if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
                echo -e "${GREEN}>>> Powering ON Bluetooth Hardware & Service...${NC}"
                rfkill unblock bluetooth
                sleep 0.5
                systemctl start bluetooth
            else
                echo -e "${RED}>>> Powering OFF Bluetooth Service & Hardware...${NC}"
                systemctl stop bluetooth
                rfkill block bluetooth
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
        echo -e "${BLUE}[DONE] System state updated.${NC}"
        sleep 0.5
    else
        echo -e "${RED}[!] Invalid selection.${NC}"
        sleep 1
    fi
done
