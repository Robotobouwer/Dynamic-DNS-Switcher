#!/bin/bash

PRIMRAY_DNS=$1
SECONDARY_DNS=$2

FILEPATH="/etc/bind/named.conf.options"

main() {
    echo "start"
    setup
    restartBIND9
    updateDNS
    echo "Done"
}

setup() {

    echo "checking if bind9 is installed"

    PACKAGES=$(dpkg -s | grep -w "Package: bind9$")

    if [ $? -ne 0 ]; then
        echo "installing bind9"
        apt install bind9 -y

        # initial file setup

        sed -i "s@// forwarders {@  forwarders {@g" ${FILEPATH}
        sed -i "s@// 	0.0.0.0;@        ${PRIMRAY_DNS};@g" ${FILEPATH}
        sed -i "s@// };@  };\n          forward only;\n          allow-query { any; };\n          recursion yes;@g" ${FILEPATH}
    else
        echo "Success!"
    fi

    echo "checking if config File is set"

    if [ ! -e ${FILEPATH} ]; then
        echo "${FILEPATH} does not exist"
        exit 1
    else
        echo "Success!"
    fi

    CURRENT_DNS=$(sed '14!d' /etc/bind/named.conf.options | sed 's/;//g' | sed 's/[[:space:]]//g')
    echo "CURRENT_DNS: $CURRENT_DNS"

}

restartBIND9() {
    echo "restart"
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
    echo "Restart Successful"

}

changeDNS() {

    local NEW_DNS=$1
    echo "changedns $NEW_DNS"

    sed -i "s@        ${CURRENT_DNS};@        ${NEW_DNS};@g" ${FILEPATH}
    restartBIND9
}

updateDNS() {


    echo "PRIMRY_DNS: $PRIMRAY_DNS"
    echo "SECONDARY_DNS: $SECONDARY_DNS"
    echo "CURRENT_DNS: $CURRENT_DNS"

    ping -c 1 ${PRIMRAY_DNS}
    DNS_IS_REACHABLE=$?

    echo "DNS_IS_REACHABLE: $DNS_IS_REACHABLE"
    echo "CURRENT_DNS: $CURRENT_DNS"

    if [[ $DNS_IS_REACHABLE -ne 0 ]] && [[ $CURRENT_DNS == "$PRIMRAY_DNS" ]]; then
        echo "Changing DNS..."
        changeDNS $SECONDARY_DNS

    elif [[ $DNS_IS_REACHABLE -eq 0 ]] && [[ $CURRENT_DNS == "$SECONDARY_DNS" ]]; then
        echo "Changing Back to PRimary DNS"
        changeDNS $PRIMRAY_DNS
    elif [[ $CURRENT_DNS != "$PRIMRAY_DNS" ]] && [[ $CURRENT_DNS != "$SECONDARY_DNS" ]]; then
        echo "DNS is NEITHER Primray or Secondary... changing to Primary"
        changeDNS $PRIMRAY_DNS
    else
        echo "NOT Changing DNS..."
    fi
}

main
