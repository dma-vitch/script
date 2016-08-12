#!/bin/bash
# convert 
echo -n "Enter database username: "
read dbuser
echo -n "Enter the MySQL password: "
read -s rootpw
echo -n "Enter database name: "
read dbname
 
#dbname=${1:-hue}
mysql -u $dbuser -p$rootpw $dbname -e "show table status where Engine !='InnoDB';" | awk 'NR>1 {print "ALTER TABLE "$1" ENGINE = InnoDB;"}' | mysql -u $dbuser -p$rootpw $dbname