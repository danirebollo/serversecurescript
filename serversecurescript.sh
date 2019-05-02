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
        $iptables -I INPUT -i venet0 -p tcp -s $i --dport 80 -j ACCEPT
    $iptables -I INPUT -i venet0 -p tcp -s $i --dport 443 -j ACCEPT
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
        $iptables -I INPUT -i venet0 -p tcp -s $i --dport 80 -j ACCEPT
    $iptables -I INPUT -i venet0 -p tcp -s $i --dport 443 -j ACCEPT
done

iptables -I INPUT -i tun0 -p tcp --dport 3306 -j ACCEPT
iptables -I INPUT -i tun0 -p tcp --dport 22 -j ACCEPT

iptables -A INPUT -p tcp --dport 80 -j DROP
iptables -A INPUT -p tcp --dport 443 -j DROP 
iptables -A INPUT -p tcp --dport 3306 -j DROP 
iptables -A INPUT -p tcp --dport 22 -j DROP
