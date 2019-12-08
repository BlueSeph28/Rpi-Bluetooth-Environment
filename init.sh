#!/bin/bash

# Create Personal Area Network via Bluetooth
apt update
apt install bluez-tools -y

cp ./config-files/pan0.netdev /etc/systemd/network/pan0.netdev
cp ./config-files/pan0.network /etc/systemd/network/pan0.network
cp ./config-files/bt-agent.service /etc/systemd/system/bt-agent.service
cp ./config-files/bt-network.service /etc/systemd/system/bt-network.service

systemctl enable systemd-networkd
systemctl enable bt-agent
systemctl enable bt-network
systemctl start systemd-networkd
systemctl start bt-agent
systemctl start bt-network

sudo bt-adapter --set Discoverable 1

# Save energy

# Power off HDMI
#tvservice --off
# Power off Usb and Ethernet
#echo 0 | sudo tee /sys/devices/platform/soc/3f980000.usb/buspower >/dev/null 