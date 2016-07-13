#!/bin/bash

#params
RED="\033[1;31m"
NORMAL="\033[0m\n"

function usage {
cat <<EOF
Usage: $(basename "$0") [options]

This script will purge hadoop services.

OPTIONS:
	-h Show help message
	-s Type of service what was deleted: (is required params()
		KAFKA
		PXF
		HAWQ
		etc.
	-u User for ambari hosts (default admin)
	-p Password for ambari users (default admin)
	-n DNS or IP of ambari hosts (is required params)
	-d port for ambari service (default 8080)
EOF
}

# Source function library.
. /etc/rc.d/init.d/functions

#default params for script
AMBARI_PORT=8080
AMBARI_USER=admin
PASSWORD=admin

if [ -z "$*" ]
    then
    printf "$RED No options found! $NORMAL \n" >&2
	usage
    exit 1
fi 

while getopts ":hs:n:u:p:d:" OPTION
do
    case $OPTION in
	h)
        usage
        exit 1
	    ;;
	s)
	    #touppercase
		SERVICE=${OPTARG^^}
	    ;;
	u)
	    AMBARI_USER=$OPTARG
	    ;;
	p)
	    PASSWORD=$OPTARG
	    ;;
	n)
	    AMBARI_HOST=$OPTARG
	    ;;
	d)
	    AMBARI_PORT=$OPTARG
	    ;;
	:)
	    printf "$RED Missing argument for -$OPTARG $NORMAL \n" >&2
	    usage
	    ;;
	\?)
	    printf "$RED Unknown option -$OPTARG $NORMAL \n" >&2
	    usage
	    exit
	    ;;
    esac
done

shift $((OPTIND - 1))

#detect name of cluster
output=$(curl -u $AMBARI_USER:$PASSWORD -i -H 'X-Requested-By: ambari' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters)
CLUSTER=$(echo $output | sed -n 's/.*"cluster_name" : "\([^\"]*\)".*/\1/p')
unset output

function check_state {
local output2=$(curl -s -u $AMBARI_USER:$PASSWORD -i -H 'X-Requested-By: ambari' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER/services/$SERVICE) 
STATE=$(echo $output2 | sed -n 's/.*"state" : "\([^\"]*\)".*/\1/p')
}

check_state

if [ "$STATE" = "STARTED" ]; then
    printf "%s\n" "Service started. Stoping service now"
#stoping service
    curl -i -H "X-Requested-By: ambari" -u $AMBARI_USER:$PASSWORD -X PUT -d '{"RequestInfo":{"context":"Stop Service"},"Body":{"ServiceInfo":{"state":"INSTALLED"}}}' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER/services/$SERVICE > /dev/null
    tries=0
        while [ $STATE != "INSTALLED" -a $tries -lt 30 ]; do
	    sleep 1
            tries=$((tries + 1))
        done
    success
    echo
fi

#run commands
curl -u $AMBARI_USER:$PASSWORD -i -H 'X-Requested-By: ambari' -X DELETE http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER/services/$SERVICE
