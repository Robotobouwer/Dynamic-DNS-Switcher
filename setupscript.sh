#!/bin/bash

DNS1=$1
DNS2=$2

cd /tmp/

echo "Cloning DNS_Switcher Repository into /tmp"

git clone https://github.com/Robotobouwer/Dynamic-DNS-Switcher.git
 
cd Dynamic-DNS-Switcher

echo "Replacing DNS Servers"

sed -i "s@DNS_1@${DNS1}@g" DNSUpdater.service
sed -i "s@DNS_2@${DNS2}@g" DNSUpdater.service

cat DNSUpdater.service

echo "moving SystemdService"

mv DNSUpdater.service DNSUpdater.timer /etc/systemd/system

echo "enabling systemdService"
systemctl daemon-reload

systemctl enable DNSUpdater.timer
systemctl enable DNSUpdater.service

echo "starting systemdService"

systemctl start DNSUpdater.timer
systemctl start DNSUpdater.service

echo "CleanUp TMP Directory"
rm -rf /tmp/Dynamic-DNS-Switcher