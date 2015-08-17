#!/bin/bash
##get Oracle Env Settings
source ./envoracle

#set date for backup
dt=`date +%F`

#get parameter
bdname=$1
host=$2
port=$3

#set backup dir
bkpdir=/opt/oracledump

expdp \"sys/sys@$host:$port/$bdname AS SYSDBA\" dumpfile=$bdname-$dt.dmp directory=DUMPS LOGFILE=$bdname-$dt.log SCHEMAS=\(GUVD_ADDR_IMP,GUVD_ADDR,GUVD_ADDR_DT,GUVD_COMMONS,GUVD_EEST,GUVD_ENTITY_RELATIONS,GUVD_JES,GUVD_NGENIE,GUVD_PARTY,GUVD_SECURITY,GUVD_TASK,GUVD_USER,GUVD_WORKS\)
# run sql from shell to clone PDB
#sqlplus sys/sys@192.168.58.102:1521/$bdname @clone_pdb.sql
if [[ $? != 0 ]]; then
    echo -e "Failed backup of $bdname!"
else
    find $bkpdir/ -type f \( -name "$bdname-*.dmp" -o -name "bdname-*.log" \) -mtime +2 #| xargs rm -f;
fi