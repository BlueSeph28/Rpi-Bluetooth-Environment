#!/bin/bash

# Create Personal Area Network via Bluetooth
apt update
apt install bridge-utils bluez python-dbus python-gobject -y

cp ./config-files/blueagent5.py ./config-files/bt-pan.py /usr/local/bin/
cp ./config-files/blueagent5.service \
./config-files/bt-pan.service \
./config-files/custom.target \
./config-files/pan-network.service \
/etc/systemd/system/

chmod 755 /usr/local/bin/*.py
 
ln -s /usr/local/bin/blueagent5.py /usr/local/bin/blueagent5
ln -s /usr/local/bin/bt-pan.py /usr/local/bin/bt-pan

echo "auto pan0\niface pan0 inet manual\n    bridge_ports none\n    bridge_stp off" \
>> /etc/network/interfaces

systemctl restart networking

systemctl enable blueagent5
systemctl enable bt-pan
systemctl list-units --type target --all
systemctl isolate custom.target
ln -sf /etc/systemd/system/custom.target /etc/systemd/system/default.target

/sbin/modprobe bnep
/bin/hciconfig hci0 lm master,accept
/sbin/ip link set pan0 up
/bin/hciconfig hci0 sspmode 0

systemctl enable pan-network

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "PRETTY_HOSTNAME=Portable-project" > /etc/machine-info

service bluetooth restart

bluetoothctl discoverable yes


# Save energy

# Power off HDMI
#tvservice --off
# Power off Usb and Ethernet
#echo 0 | sudo tee /sys/devices/platform/soc/3f980000.usb/buspower >/dev/null 