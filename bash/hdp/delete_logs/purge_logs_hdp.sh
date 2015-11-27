#!/bin/bash
#params
RED="\033[1;31m"
NORMAL="\033[0m\n"

#Block service function
function usage {
cat <<EOF
Usage: `basename $0` [options]

This script will purge old logs from hadoop services.

OPTIONS:
	-h 	Show help message
	-u	Type of service what was purged logs:
		    kafka
		    oozie
		    falcon
		    metrics
		    hive
		    hbase
	-d	How many days to keep logs from current date (if you not set this option when use default is 7)
	
EOF
}

#check user who execute script
function check_user {
local usr=`whoami`
if [[ $usr != "root" ]]; then
	if [[ $usr != $user ]]; then
	    echo "Script must be run as user: $1 or root"
	    exit 1
	else
	    return 0
        fi
fi
}

#Block primary functions
function kafka {
echo "delete logs for service kafka, keep last $1 days"
find /var/log/kafka/ -type f -mtime +$1 \( -name 'server.log.*' -o -name 'controller.log.*' -o -name 'state-change.log.*' \) | xargs rm -f;
}

function hive {
echo "delete logs for service hive, keep last $1 days"
find /var/log/hive/ -type f -mtime +$1 \( -name 'hiveserver2.log.*' -o -name 'hivemetastore.log.*' \) | xargs rm -f;
}

function hbase {
echo "delete logs for service hbase, keep last $1 days"
find /var/log/hbase/ -type f -mtime +$1 -name 'gc.log-*' | xargs rm -f;
}

function oozie {
echo "delete logs for service oozie, keep last $1 days"
find /var/log/oozie/ -type f -mtime +$1 \( -name 'oozie.log.*' -o -name 'oozie-instrumentation.log.*' \) | xargs rm -f;
}

function falcon {
echo "delete logs for service falcon, keep last $1 days"
find /var/log/falcon/ -type f -mtime +$1 -name 'falcon.application.log.*' | xargs rm -f;
}

function metrics {
echo "delete logs for service ambari-metrics, keep last $1 days"
find /var/log/ambari-metrics-collector/ -type f -mtime +$1 \( -name 'gc.log-*' -o -name 'ambari-metrics-collector.log.*' \)| xargs rm -f;
}

#-----------------------------
#if you did not use shift in getops when uncommet this block
#check for count options 
#if [ "$#" -eq 0 ]
#    then 
#	usage
#	exit 0
#fi 

#default params days to keep logs
days=7

while getopts ":hu:d:" OPTION
do
    case $OPTION in
	h)
		usage
		exit 1
	    ;;
	d) 
	    days=$OPTARG	
	    ;;
	u)
	    user=$OPTARG
	    ;;
	:)
	    printf "$RED Missing argument for -"$OPTARG" $NORMAL \n" >&2
	    usage
	    ;;
        \?)	
	    printf "$RED Unknown option -"$OPTARG" $NORMAL \n" >&2
	    usage
	    exit
	    ;;
    esac
done
shift $((OPTIND - 1))

case $user in
    kafka)
		check_user $user
		kafka $days
		;;
    oozie)
		check_user $user
		oozie $days
		;;
    hive)
		check_user $user
		hive $days
		;;
    hdfs)
		check_user $user
		hdfs $days
		;;
    falcon)
		check_user $user
		falcon $days
		;;
    metrics)
		check_user $user
		metrics $days
		;;
	*)
		printf "$RED Wrong parametrs for running $NORMAL \n" >&2
		usage
		;;
esac
exit 0
