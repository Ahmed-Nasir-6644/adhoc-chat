#!/bin/bash
# ADHOC-CHAT SUDOERS SETUP GUIDE
# Run this script with: sudo bash setup-sudoers.sh

echo "Setting up sudoers for adhoc-chat..."

# Create sudoers.d file with appropriate permissions
sudo tee /etc/sudoers.d/adhoc-chat > /dev/null << 'EOF'
# Allow adhoc-chat network setup without password prompts
# These commands will run without requiring a password when prefixed with sudo

# Main setup script
%sudo ALL=(ALL) NOPASSWD: /home/ahmed-nasir/Desktop/CApp/adhoc-chat/backend/setup-adhoc-network.sh

# Package management (for initial setup)
%sudo ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get

# Network management
%sudo ALL=(ALL) NOPASSWD: /usr/bin/systemctl
%sudo ALL=(ALL) NOPASSWD: /usr/sbin/killall, /bin/killall
%sudo ALL=(ALL) NOPASSWD: /sbin/ip
%sudo ALL=(ALL) NOPASSWD: /usr/bin/iw
%sudo ALL=(ALL) NOPASSWD: /sbin/ifconfig

# Python (for setup script)
%sudo ALL=(ALL) NOPASSWD: /usr/bin/python3
EOF

# Set correct permissions (sudoers files must be 0440)
sudo chmod 440 /etc/sudoers.d/adhoc-chat

echo "Sudoers configuration complete!"
echo "Users in the 'sudo' group can now run ad-hoc network setup without password prompts."
echo ""
echo "To verify the setup works, run:"
echo "  sudo /home/ahmed-nasir/Desktop/CApp/adhoc-chat/backend/setup-adhoc-network.sh --help"
