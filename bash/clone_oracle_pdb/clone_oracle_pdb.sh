#!/bin/bash
#Clone pdb to new intance

##get Oracle Env Settings
if [ -s "/home/oracle/script/envoracle.cfg" ]; then
    source /home/oracle/script/envoracle.cfg
else
    echo "ERROR: file envoracle.cfg not exist,please set environment for oracle"
fi

# run sql from shell to clone PDB
sqlplus / as sysdba @/home/oracle/script/clone_pdb.sql $1
#sqlplus sys/sys@192.168.58.102:1521/$bdname @clone_pdb.sql

if [[ $? != 0 ]]; then
    echo -e "Failed clone of $bdname!"
#else
#    echo -e "Done clone of $bdname!"
fi
