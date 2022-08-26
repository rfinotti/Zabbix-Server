#!/bin/sh

#Script by Riccardo Finotti.


############################
##### Script Variables #####
############################

#Databse Root Password:
root_pass="rootDBPass"

#Zabbix Database Password:
db_pass="zabbixDBpass"

#Zabbix Server FQDN
hostname="zabbix.local"

#Server TimeZone
region_capital="Europe/Rome"

#Your Zabbix Server's IP address will be automatically passed to the script.
#If you wish to set it up manually, please comment line 25 and uncomment line 27 and add you ip address.

ipv4=$(/sbin/ip -o -4 addr list ens33 | awk '{print $4}' | cut -d/ -f1)

#ipv4="192.168.0.10"

##########################
##### SCRIPTS BEGINS #####
##########################
sudo apt update && apt upgrade -y

sed -i "s@ubuntu@$hostname@g" /etc/hostname

sed -i "s@127.0.1.1 ubuntu@$ipv4 $hostname@g" /etc/hosts

timedatectl set-timezone $region_capital



#############################
##### Installing Zabbix #####
#############################
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-3%2Bubuntu20.04_all.deb

dpkg -i zabbix-release_6.0-3+ubuntu20.04_all.deb

sudo apt update


sudo apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

sudo apt -y install mysql-server

systemctl start mysql
systemctl enable mysql


##########################
##### Securing MySQL #####
##########################
echo "Securing MySQL Installation"

mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$root_pass';"
mysql -uroot -p$root_pass -e "DELETE FROM mysql.user WHERE User='';"
mysql -uroot -p$root_pass -e "DROP DATABASE test;"
mysql -uroot -p$root_pass -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -uroot -p$root_pass -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '$db_pass';"
mysql -uroot -p$root_pass -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
mysql -uroot -p$root_pass -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
mysql -uroot -p$root_pass -e "FLUSH PRIVILEGES;"

echo "Creating Zabbix's Database"

zcat /usr/share/doc/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p$db_pass zabbix

#########################
##### Zabbix Apache #####
#########################
echo "Setting up apache"

sed -i "s@# php_value date.timezone Europe/Riga@php_value date.timezone $region_capital@g" /etc/zabbix/apache.conf

systemctl restart apache2
systemctl enable apache2

#########################
##### Zabbix Server #####
#########################
echo "Setting up Zabbix Server configuration"

cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf_orig

sed -i "s@# DBPassword=@DBPassword=$db_pass@g" /etc/zabbix/zabbix_server.conf

#########################
##### Zabbix Agents #####
#########################
echo "Setting up Zabbix Agent"

cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf_orig

cat > /etc/zabbix/zabbix_agentd.conf <<EOF
LogFile=/tmp/zabbix_agentd.log
Server=127.0.0.1
ListenPort=10050
ServerActive=127.0.0.1
Hostname=$hostname
HostMetadata=release
UserParameter=release,cat /etc/*release
EOF

##################################################
# This step will create a directory to fetch     #
# the zabbix_agent configuration for the clients #
##################################################
mkdir -p /var/www/html/zabbix_clients

cat > /var/www/html/zabbix_clients/zabbix_agentd.conf <<EOF
LogFile=/tmp/zabbix_agentd.log
Server=$ipv4
ListenPort=10051
ServerActive=$ipv4
HostnameItem=system.hostname
HostMetadata=release
UserParameter=release,cat /etc/*release
EOF

#################################
##### Let's clean things up #####
#################################

systemctl restart zabbix-server zabbix-agent 

systemctl enable zabbix-server zabbix-agent

apt clean

echo "Installation and setup finished."
echo " "
echo "The server will reboot in 5 seconds."

sleep 5

shutdown -r now
###################
##### THE END #####
###################