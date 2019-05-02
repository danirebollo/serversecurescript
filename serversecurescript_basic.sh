#!/bin/bash

iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F

if [ $(whoami) != "root" ]
then
    echo "Please run as root"
    exit
fi 
type="4"
for i in `curl -s https://www.cloudflare.com/ips-v$type`
do
    if [ $type = "6" ]
    then
        iptables="ip6tables"
    else
        iptables="iptables"
    fi
        $iptables -I INPUT -p tcp -s $i --dport 80 -j ACCEPT
    $iptables -I INPUT -p tcp -s $i --dport 443 -j ACCEPT
done

type="6"
for i in `curl -s https://www.cloudflare.com/ips-v$type`
do
    if [ $type = "6" ]
    then
        iptables="ip6tables"
    else
        iptables="iptables"
    fi
        $iptables -I INPUT -p tcp -s $i --dport 80 -j ACCEPT
    $iptables -I INPUT -p tcp -s $i --dport 443 -j ACCEPT
done

iptables -A INPUT -p tcp --dport 80 -j DROP
iptables -A INPUT -p tcp --dport 443 -j DROP
