#!/bin/sh
#Script by Riccardo Finotti.

############################
##### Script Variables #####
############################

#Zabbix Server
zbx_ipv4="server_ip"
zbx_fqdn="server_hostname"


#############################
##### Installing Zabbix #####
#############################
dist=$(awk '/DISTRIB_ID=/' /etc/*-release | sed 's/DISTRIB_ID=//' | tr '[:upper:]' '[:lower:]')
rel=$(awk '/DISTRIB_RELEASE=/' /etc/*-release | sed 's/DISTRIB_RELEASE=//')

wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-3%2B"$dist$rel"_all.deb

dpkg -i zabbix-release_6.0*

sudo apt update

sudo apt -y install zabbix-sql-scripts zabbix-agent

echo "$zbx_ipv4 $zbx_fqnd" >> /etc/hosts

rm /etc/zabbix/zabbix_agentd.conf

sleep 5

wget http://zabbix.local/agents/linux/zabbix_agentd.conf -P /etc/zabbix/

ipv4=$(/sbin/ip -o -4 addr list ens33 | awk '{print $4}' | cut -d/ -f1)

sed -i "s@ListenIP=@ListenIP=$ipv4@g" /etc/zabbix/zabbix_agentd.conf

systemctl restart zabbix-agent

sudo systemctl status zabbix-agent