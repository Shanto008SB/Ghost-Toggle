![Shanto008SB](https://github.com/user-attachments/assets/731be8d1-c38f-4d31-830b-11716f2622c2)

# ***Ghost-Toggle***
Ghost-Toggle is an automated service management utility for Kali Linux that simplifies system administration through a professional terminal interface.

Key Benefits:

1. **Auto-Discovery:**
  Scans for all system and third-party services (SSH, Apache, Acunetix) dynamically so no manual lists are needed.
2. **Auto-Sudo:**
  Automatically escalates to root at launch, handling all permissions with a single password entry.
3. **Aligned Interface:**
  Uses precision formatting to keep [ ON ] and [ OFF ] labels in a perfectly straight line, regardless of service name length.
4. **Hard-Toggle Security:**
  Uses rfkill to ensure Bluetooth is disabled at the hardware level for true privacy.
5. **Global Access:**
  Once installed in /usr/local/bin, it can be launched by simply typing manage from any directory.
  
# Installation:
_______________
```bash
git clone https://github.com/Shanto008SB/Ghost-Toggle.git
```

# Setup:
________
***Setup For current derectory***
```bash
sudo chmod +x manage_all.sh
```
```bash
sudo chmod +x deep_scan.sh
```

***Set Global Executable Permissions***

for manage_all.sh
```bash
sudo mv manage_all.sh /usr/local/bin/manage
```
```bash
sudo chmod +x /usr/local/bin/manage
```
for deep_scan.sh
```bash
sudo mv deep_scan.sh /usr/local/bin/managepro
```
```bash
sudo chmod +x /usr/local/bin/managepro
```
# usage:
For general usage,
```bash
./manage_all.sh
```
Full Scan
```bash
./deep_scan.sh
```
# Global usage
***Run***
For general usage,
```bash
manage
```
***Run***
For full Scan
```bash
managepro
```
# general scan
<img width="964" height="548" alt="image" src="https://github.com/user-attachments/assets/1cba15e8-5d01-490d-aa1a-609e0352c0cd" />

# full Scan
<img width="1281" height="959" alt="image" src="https://github.com/user-attachments/assets/789b70e1-64be-44a5-97cd-00e5a8934233" />

