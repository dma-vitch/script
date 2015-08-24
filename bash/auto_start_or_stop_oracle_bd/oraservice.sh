#!/bin/bash
# chkconfig: 95 10
# description: Oracle auto start-stop script \
# This script spelled out commands to start and stop and listener'a instance \
# The script will run at startup and shutdown of the operating system.

### BEGIN INIT INFO
# Provides:          Oracle
# Required-Start:    $network
# Required-Stop:     $network
# Default-Start:     2 3 4
# Default-Stop:      0 1 6
# Description:       Oracle DB
# Short-Description: Oracle service provided by Oracle
### END INIT INFO

# Change the value of ORACLE_HOME to specify the correct Oracle home
# directory for your installation.
#ORACLE_HOME=/oracleDB/app/oracle/product/12.0.1/dbhome_1

# Set OWNER to the user id of the owner of the Oracle database in ORACLE_HOME.
OWNER=oracle
RETVAL=0

if [ ! -f $ORACLE_HOME/bin/dbstart ]
	then
	echo "Oracle startup: cannot start"
exit

if [ -s "/home/oracle/script/envoracle.cfg" ]; then
    source /home/oracle/script/envoracle.cfg
else
    echo "ERROR: file envoracle.cfg not exist,please set environment for oracle"
	exit
fi

case $1 in
'start')
        su - $OWNER -c "$ORACLE_HOME/bin/lsnrctl start"
        su - $OWNER -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME"
        ;;
'stop')
        su - $OWNER -c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME"
        su - $OWNER -c "$ORACLE_HOME/bin/lsnrctl stop"
        ;;
*)
        echo "usage: $0 {start|stop}"
        exit
        ;;
esac

exit $RETVAL