#!/bin/bash
#check entering count arguments
if [[  $# -lt 2 || $# -gt 3 ]]; then
	echo "Usage: $0 bd_name IP_adress port(by default 1521)"
	exit
fi

##get Oracle Env Settings
if [ -s "/home/oracle/script/envoracle.cfg" ]; then
    source /home/oracle/script/envoracle.cfg
else
	echo "ERROR: file envoracle.cfg not exist,please set environment for oracle"
fi

#set date for backup
dt=`date +%F`

#get parameter
bdname=$1
iphost=$2
dport=1521
port=${3:-$dport}

#set backup directory
bkpdir=/opt/oracledump

expdp \"sys/sys@$iphost:$port/$bdname AS SYSDBA\" dumpfile=$bdname-$dt.dmp directory=DUMPS LOGFILE=$bdname-$dt.log SCHEMAS=\(USER_TASK,USER_ADDR,USER_WORKS\)
# run sql from shell to clone PDB
#sqlplus sys/sys@$iphost:$port/$bdname @clone_pdb.sql
if [[ $? != 0 ]]; then
    echo -e "Failed backup of $bdname!"
else
    find $bkpdir/ -type f \( -name "$bdname-*.dmp" -o -name "bdname-*.log" \) -mtime +2 | xargs rm -f;
fi