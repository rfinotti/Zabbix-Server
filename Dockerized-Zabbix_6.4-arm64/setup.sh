#!/bin/bash

# Set MySQL root password from environment variable
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | debconf-set-selections

# Create MySQL data directory
mkdir -p /var/lib/mysql

# Start MySQL service
service mysql start

# Set MySQL database and user details from environment variables
MYSQL_DB_NAME=${MYSQL_DB_NAME}
MYSQL_DB_USER=${MYSQL_DB_USER}
MYSQL_DB_PASS=${MYSQL_DB_PASS}

# Create Zabbix database, user, and execute SQL scripts
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "create database $MYSQL_DB_NAME character set utf8mb4 collate utf8mb4_bin;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "create user $MYSQL_DB_USER@localhost identified by '$MYSQL_DB_PASS';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "grant all privileges on $MYSQL_DB_NAME.* to $MYSQL_DB_USER@localhost;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "set global log_bin_trust_function_creators = 1;"
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -u$MYSQL_DB_USER -p$MYSQL_DB_PASS $MYSQL_DB_NAME
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "set global log_bin_trust_function_creators = 0;"

# Alter the line in the Zabbix server configuration file
sed -i "s/# DBPassword=/DBPassword=$MYSQL_DB_PASS/" /etc/zabbix/zabbix_server.conf

# Keep the container running
tail -f /dev/null
