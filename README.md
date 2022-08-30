# Zabbix-Server
 Standalone Zabbix Server installer

I've created this script just for fun, to see how much I could automate Zabbix-Server and Zabbix-Agent installation  in Raspberry and Ubuntu Servers.
The script will automatically detect the you Distribution and Release, will install MariaDB on your raspberry and Mysql-Server on Ubuntu.

You have two options:
Download via Git Clone the entire Repository, or execute the following commands:

#Installer for Ubuntu:
wget https://raw.githubusercontent.com/rfinotti/Zabbix-Server/master/Zabbix_6.0-3_Ubuntu/Server/install_server.sh
chmod +x install_server.sh


#Installer for Raspberry:
wget https://raw.githubusercontent.com/rfinotti/Zabbix-Server/master/Zabbix_6.0-3_Raspberry/Server/install_server.sh
chmod +x install_server.sh

Before proceeding with the installation please remember to edit the variables in the "install_server.sh" according to your necessity:
    
    #Databse Root Password:
        root_pass="rootDBPass"

    #Zabbix Database Password:
        db_pass="zabbixDBpass"

    #Zabbix Server FQDN
        hostname="zabbix.local"

    #Server TimeZone
        mytimezone="Europe/Rome"


One you have saved the modified file ypu can launch the installation script with the following command:

/bin/sh install_server.sh
or
./install_server.sh

===========================================================================================================================================================

I had so much fun creating these scripts and I hope they will help you out.

Leave a comment if you want, let me know what do you think.

HAVE FUN!!!