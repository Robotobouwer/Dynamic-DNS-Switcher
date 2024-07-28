# DNS_Switcher

This is a Systemd managed Service to switch between two predefined DNS Severs, depending on which is available at the time.
The according check is run every 30 seconds.

## Setup
#### You should run the following steps as sudo: 

1. Edit **DNSUpdater.service** and replace **DNS_1** and **DNS_2** with your according DNS-Addresses
2. Copy **DNSUpdater.service** and **DNSUpdater.timer** to **/etc/systemd/system/**
3. Copy updatescript.sh to **/opt/**
4. Run the command: **systemctl daemon-reload**
5. Run the command: **systemctl start DNSUpdater.service**
6. Run the command: **systemctl enable DNSUpdater.service** -> This starts the Service upon system restart
7. Set your Routers DNS Server to the Machine that runs the UpdaterService


### Enjoy!

