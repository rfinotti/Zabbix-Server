#!/bin/sh

#Script by Riccardo Finotti.

############################
##### Script Variables #####
############################

#Zabbix Server
zbx_ipv4="192.168.10.5"
zbx_fqdn="zabbix.local"


#Server TimeZone
region_capital="Europe/Rome"


#############################
##### Installing Zabbix #####
#############################
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-3%2Bubuntu20.04_all.deb

dpkg -i zabbix-release_6.0-3+ubuntu20.04_all.deb

sudo apt update

sudo apt -y install zabbix-sql-scripts zabbix-agent

echo "$zbx_ipv4 $zbx_fqnd" >> /etc/hosts

rm /etc/zabbix/zabbix_agentd.conf

wget http://zabbix.local/zabbix_clients/zabbix_agentd.conf -P /etc/zabbix/

ipv4=$(/sbin/ip -o -4 addr list ens33 | awk '{print $4}' | cut -d/ -f1)

sed -i "s@ListenIP=@ListenIP=$ipv4@g" /etc/zabbix/zabbix_agentd.conf

systemctl restart zabbix-agent

sudo systemctl status zabbix-agent