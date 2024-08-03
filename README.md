# DNS_Switcher

This is a Systemd managed Service to switch between two predefined DNS Severs, depending on which is available at the time.
The according check is run every 30 seconds.

## Setup
#### You should run the following steps as sudo: 

1. Login to your Server 
2. Run the following Command: 

<code>
curl https://raw.githubusercontent.com/Robotobouwer/Dynamic-DNS-Switcher/main/setupscript.sh | sudo /bin/bash -s *DNS1* *DNS2*
 
</code>


### Enjoy!

