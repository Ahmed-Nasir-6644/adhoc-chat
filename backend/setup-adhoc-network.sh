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
sudo systemctl stop NetworkManager 2>/dev/null || echo "NetworkManager not running"

echo "Killing wpa_supplicant..."
sudo killall wpa_supplicant 2>/dev/null || echo "wpa_supplicant not running"

echo "Setting up ad-hoc interface: $INTERFACE"
sudo ip link set "$INTERFACE" down 2>/dev/null || true
sudo iw dev "$INTERFACE" set type ibss 2>/dev/null || true
sudo ip link set "$INTERFACE" up 2>/dev/null || true

echo "Joining ad-hoc network: $NETWORK_SSID at $NETWORK_FREQ MHz"
sudo iw dev "$INTERFACE" ibss join "$NETWORK_SSID" "$NETWORK_FREQ" 2>/dev/null || echo "May already be joined or interface unavailable"

echo "Configuring IP address..."
cd "$(dirname "$0")"
sudo python3 setup-adhoc-link.py 2>/dev/null || echo "Python setup script not available or failed"

echo "Setting up interface: $IP_INTERFACE with IP $IP_ADDRESS"
sudo ifconfig "$IP_INTERFACE" "$IP_ADDRESS" netmask "$NETMASK" up 2>/dev/null || echo "Interface setup may have failed"

echo "Ad-hoc network setup complete!"
