#!/bin/bash

local PRIMRAY_DNS=$1
local SECONDARY_DNS=$2

main() {

    setup

    echo "Running DNS Switcher:" 
    while (true); do
       
        primaryDnsIsReachable
        
        while (${DNS_IS_REACHABLE} -eq 0)
        do
            primaryDnsIsReachable
            sleep 5
        done

    done

}


setup() {

    echo "checking if bind9 is installed"

   local PACKAGES=$(dpkg -l | grep "bind9")

    if [ $? -ne 0 ]; then
        echo "installing bind9"
        apt install bind9 -y
    else
        echo "Success!"    
    fi

   local FILEPATH="/etc/bind/named.conf.options"
    echo "checking if config File is set"
    if [ ! -e ${FILEPATH} ]; then
        echo "${FILEPATH} does not exist"
        exit 1
    else
        echo "Success!" 
    fi

    # initial file setup

    sed -i "s@// forwarders {@  forwarders {@g" ${FILEPATH}
    sed -i "s@// 	0.0.0.0;@        ${PRIMRAY_DNS};@g" ${FILEPATH}
    sed -i "s@// };@  };\n          forward only;@g" ${FILEPATH}

    named-checkconf "/etc/bind/named.conf"

    if [ $? -ne 0 ]; then
        echo "config not valid"
    fi

    named-checkconf ${FILEPATH}

    if [ $? -ne 0 ]; then
        echo "config not valid"
    fi


    echo "Starting bind9 service" 
    service bind9 restart

}

primaryDnsIsReachable(){

    local DNS_IS_REACHABLE

    ping -c5 ${PRIMRAY_DNS}

    if [$? -eq 0];then
        DNS_IS_REACHABLE=1
    else
        DNS_IS_REACHABLE=0
    fi

    

}

main

