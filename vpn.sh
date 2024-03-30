#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CLEAR='\033[0m' # No Color

function turn_off_vpn(){
        echo -e "${BLUE}Turning off SSHuttle VPNs ...${CLEAR}"
        systemctl stop "sshuttle@*.service"
        echo -e "${GREEN}Done!${CLEAR}\n"
}

function turn_on_vpn(){
        if systemctl is-active "sshuttle@*.service" | grep -q "active"; then
                echo -e "\n${RED}You have an already ACTIVE VPN. Turn it off first:${CLEAR}"
                systemctl list-units --full --all --no-legend "sshuttle@*" | grep --color=never "active" | grep -o "sshuttle@.*service"
                echo
        else
                echo -e "\n${BLUE}------------- Selected VPN: $VPN_SSH_HOST -------------${CLEAR}"
                systemctl start sshuttle@$VPN_SSH_HOST.service
                echo -e "${GREEN}Done!${CLEAR}\n"
        fi
}

VPN_SSH_HOST=

case "$1" in
    "off")
        turn_off_vpn;
        ;;
    *)
        VPN_SSH_HOST=${1:-image};
        turn_on_vpn;
        ;;
esac