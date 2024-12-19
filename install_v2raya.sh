#!/bin/bash
 
# Add the public key certificate
echo "Adding the public key certificate..."
wget https://downloads.sourceforge.net/project/v2raya/openwrt/v2raya.pub -O /etc/opkg/keys/94cc2a834fb0aa03 || {
    echo "Error downloading the public key certificate" && exit 1
}

# Add the repository to customfeeds.conf
echo "Adding the repository to customfeeds.conf..."
echo "src/gz v2raya https://downloads.sourceforge.net/project/v2raya/openwrt/$(. /etc/openwrt_release && echo "$DISTRIB_ARCH")" | tee -a "/etc/opkg/customfeeds.conf"

# Update the package list
echo "Updating the package list..."
opkg update || { echo "Error updating the package list" && exit 1; }

# Install v2raya and dependencies
echo "Installing v2raya and dependencies..."
opkg install v2raya || { echo "Error installing v2raya" && exit 1; }
opkg install kmod-nft-tproxy || { echo "Error installing kmod-nft-tproxy" && exit 1; }
opkg install iptables-mod-conntrack-extra \
  iptables-mod-extra \
  iptables-mod-filter \
  iptables-mod-tproxy \
  kmod-ipt-nat6 || { echo "Error installing iptables modules" && exit 1; }

# Install xray-core
echo "Installing xray-core..."
opkg install xray-core || { echo "Error installing xray-core" && exit 1; }

# Install the LuCI interface for v2raya
echo "Installing luci-app-v2raya..."
opkg install luci-app-v2raya || { echo "Error installing luci-app-v2raya" && exit 1; }

# Configure v2raya
echo "Configuring v2raya..."
uci set v2raya.config.enabled='1'
uci commit v2raya

# Enable autostart and start v2raya
echo "Enabling autostart and starting v2raya..."
/etc/init.d/v2raya enable
/etc/init.d/v2raya start || { echo "Error starting v2raya" && exit 1; }

# Determine the router's IP address
IP_ADDR=$(ip -4 addr show br-lan | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# Finish installation
echo "Installation and configuration of v2raya are complete."
echo "To configure v2raya, open the following address in your browser: http://$IP_ADDR:2017"
