#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

# check required packet pwgen
IS_EXISTING=$(rpm -qa | grep pwgen | wc -l)
if [ $IS_EXISTING -gt 0 ]; then
    printf "%40s\n" "${GREEN} Required packet pwgen - installed ${NORMAL}"
else
    printf "%40s\n" "${RED} Please, install Required packet pwgen ${NORMAL}"
    exit 1
fi

# create random password
dbpw=$(pwgen -s 40 1)
#dbpw="$(openssl rand -base64 12)"
#dbuser=${1:-$(echo $USER)}
dbuser=${1:-hue}
# replace "-" with "_" for database username
dbname=${dbuser//[^a-zA-Z0-9]/_}

# If /home/user/.my.cnf exists then it won't ask for root password
if [ -f ~/.my.cnf ]; then
#if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE ${dbname} ENGINE='InnoDB' /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${dbuser}@localhost IDENTIFIED BY '${dbpw}';"
    #multiple hosts
    #mysql -e "CREATE USER '${dbuser}'@'%' IDENTIFIED BY '${dbpw}';"
    #mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'%';"
    mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else
    printf "%40s\n" "Please enter root user MySQL password!"
    read rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} ENGINE='InnoDB' /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p${rootpasswd} -e "CREATE USER ${dbuser}@localhost IDENTIFIED BY '${dbpw}';"
    #multiple hosts
    #mysql -uroot -p${rootpasswd} -e "CREATE USER '${dbuser}'@'%' IDENTIFIED BY '${dbpw}';"
    #mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'%';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'localhost';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
fi

if [ $? != "0" ]; then
    printf "%40s\n" "${RED} [Error]: Database creation failed ${NORMAL}"
    exit 1
else
    echo "------------------------------------------"
    printf "%40s\n" "${GREEN} Database has been created successfully "
    echo "------------------------------------------"
    echo " DB Info: "
    echo ""
    echo " DB Name: $dbname"
    echo " DB User: $dbuser"
    echo " DB Pass: $dbpw"
    echo ""
    echo "------------------------------------------${NORMAL}"
fi