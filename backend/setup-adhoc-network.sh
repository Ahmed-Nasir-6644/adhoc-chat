#!/bin/bash

# Setup ad-hoc network
# This script configures the wireless interface to join an ad-hoc network

set -e

INTERFACE="wlp2s0"
IP_INTERFACE="wlp2s0"
NETWORK_SSID="ISE-19"
NETWORK_FREQ="2437"
IP_ADDRESS="10.10.1.1"
NETMASK="255.255.255.0"

echo "Installing required packages..."
sudo apt-get update -qq 2>&1 | grep -v "file:/cdrom" || true
sudo apt install -y net-tools 2>/dev/null || echo "net-tools may already be installed"
sudo apt-get install -y iperf htop iw wireless-tools batctl 2>/dev/null || echo "Some packages may already be installed"

echo "Stopping NetworkManager..."
sudo systemctl stop NetworkManager || echo "NetworkManager not running"
sudo systemctl disable NetworkManager || echo "Could not disable NetworkManager"

echo "Killing wpa_supplicant..."
sudo killall wpa_supplicant 2>/dev/null || echo "wpa_supplicant not running"

# Wait a moment to ensure services are stopped
sleep 2

echo "Setting up ad-hoc interface: $INTERFACE"
sudo ip link set "$INTERFACE" down || true
sudo iw dev "$INTERFACE" set type ibss || true
sudo ip link set "$INTERFACE" up || true

echo "Joining ad-hoc network: $NETWORK_SSID at $NETWORK_FREQ MHz"
sudo iw dev "$INTERFACE" ibss join "$NETWORK_SSID" "$NETWORK_FREQ" || echo "May already be joined or interface unavailable"

echo "Configuring IP address..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sudo python3 "$SCRIPT_DIR/setup-adhoc-link.py" || echo "Python setup script not available or failed"

echo "Setting up interface: $IP_INTERFACE with IP $IP_ADDRESS"
sudo ifconfig "$IP_INTERFACE" "$IP_ADDRESS" netmask "$NETMASK" up || echo "Interface setup may have failed"

echo "Ad-hoc network setup complete!"
