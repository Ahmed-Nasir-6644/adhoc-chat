# Adhoc Chat - Network Setup Integration

## Overview
When a user clicks "Join" on the home page, the app will:
1. Execute the network setup script (runs ad-hoc network configuration)
2. Wait for completion
3. On success → Enter the messaging room
4. On failure → Show an error dialog

## Setup Steps (One-time)

### 1. Configure Sudoers (No Password Prompts)
Run the sudoers setup script provided:
```bash
sudo bash /home/ahmed-nasir/Desktop/CApp/adhoc-chat/backend/setup-sudoers.sh
```

This allows the app to run network commands without password prompts.

**OR manually setup sudoers:**
```bash
sudo visudo -f /etc/sudoers.d/adhoc-chat
```

Add the following content:
```
# Allow adhoc-chat network setup without password
%sudo ALL=(ALL) NOPASSWD: /home/ahmed-nasir/Desktop/CApp/adhoc-chat/backend/setup-adhoc-network.sh
%sudo ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get
%sudo ALL=(ALL) NOPASSWD: /usr/bin/systemctl
%sudo ALL=(ALL) NOPASSWD: /usr/sbin/killall, /bin/killall
%sudo ALL=(ALL) NOPASSWD: /sbin/ip
%sudo ALL=(ALL) NOPASSWD: /usr/bin/iw
%sudo ALL=(ALL) NOPASSWD: /sbin/ifconfig
%sudo ALL=(ALL) NOPASSWD: /usr/bin/python3
```

**IMPORTANT:** Save with `Ctrl+X` then `Y` then `Enter` (if using nano)

### 2. Verify Setup
Test that sudoers is configured correctly:
```bash
sudo /home/ahmed-nasir/Desktop/CApp/adhoc-chat/backend/setup-adhoc-network.sh
```

The script should run without asking for a password.

## Running the App

### Build
```bash
cd /home/ahmed-nasir/Desktop/CApp/adhoc-chat/build
cmake --build .
```

### Run
```bash
./build/appchatApp
```

## User Flow

1. **Launch App** → Sees registration dialog
2. **Register** → Directed to home page (with Join interface)
3. **Enter Room Code or Select Public Room** → Clicks "Join"
4. **App Executes Setup Script**:
   - Installs network tools (net-tools, iperf, htop, iw, wireless-tools, batctl)
   - Stops NetworkManager
   - Stops wpa_supplicant
   - Configures wireless interface (wlp2s0) for ad-hoc mode
   - Joins ISE-19 network at 2437 MHz
   - Runs Python setup (batman config)
   - Sets up interface wlp3s0 with IP 10.10.1.1
5. **On Success** → User enters messaging room
6. **On Failure** → Error dialog shows failure reason

## Configuration

The setup script uses these settings (editable in `backend/setup-adhoc-network.sh`):
```bash
INTERFACE="wlp2s0"          # Wireless interface for ad-hoc
IP_INTERFACE="wlp3s0"       # Interface to assign IP
NETWORK_SSID="ISE-19"       # Ad-hoc network name
NETWORK_FREQ="2437"         # Channel frequency
IP_ADDRESS="10.10.1.1"      # Assigned IP address
NETMASK="255.255.255.0"     # Network mask
```

## Files Created/Modified

### New Files:
- `NetworkSetup.h` - C++ backend class for running setup
- `NetworkSetup.cpp` - Implementation 
- `backend/setup-adhoc-network.sh` - Main setup script
- `backend/setup-sudoers.sh` - Sudoers configuration script

### Modified Files:
- `main.cpp` - Exposes NetworkSetup to QML
- `Main.qml` - Added network setup UI flow and signal handlers
- `HomePage.qml` - Already had join interface, now wired to backend
- `CMakeLists.txt` - Added NetworkSetup sources

## Troubleshooting

### "Setup failed" error
1. Check that sudoers is configured: `sudo -l | grep setup-adhoc`
2. Run the script manually to see actual error: `sudo bash backend/setup-adhoc-network.sh`
3. Check network interface name (might be different): `ip link show`
4. Update interface names in `backend/setup-adhoc-network.sh`

### Script hangs during setup
- Likely waiting for password (sudoers not configured)
- Run sudoers setup again: `sudo bash backend/setup-sudoers.sh`

### Interface not found
- Edit `backend/setup-adhoc-network.sh` to match your interface names
- Find interfaces with: `ip link show` or `iwconfig`

## Notes
- Script requires sudo privileges (handled via sudoers)
- First-run installs packages (apt-get) - may take time
- Only the first user to join needs to do setup (configures network for all)
- NetworkManager is stopped during setup (can be restarted after if needed)
