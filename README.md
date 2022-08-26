# Zabbix-Server
 Standalone Zabbix Server installer

I've created this script just for fun, to see how much I could automate Zabbix-Server and Zabbix-Agent installation  in Raspberry and Ubuntu Servers.
The script will automatically detect the you Distribution and Release, will install MariaDB on your raspberry and Mysql-Server on Ubuntu.


In the "install_server.sh" you will see the following variables that can be modified according to your necessity:
    
    #Databse Root Password:
        root_pass="rootDBPass"

    #Zabbix Database Password:
        db_pass="zabbixDBpass"

    #Zabbix Server FQDN
        hostname="zabbix.local"

    #Server TimeZone
        mytimezone="Europe/Rome"


**Remember to edit the variables at the begining of the script before launching it**

I had so much fun creating the scripts and learning from my mistakes.

Leave a comment, let me know what do you think... and most important of all...

HAVE FUN!!!