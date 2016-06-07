#!/bin/bash
#params
RED="\033[1;31m"
NORMAL="\033[0m\n"

function usage {
cat <<EOF
Usage: $(basename "$0") [options]

This script will purge old logs from hadoop services.

OPTIONS:
	-h 	Show help message
	-s	Type of service what was deleted: (is required params()
		    KAFKA
		    PXF
		    HAWQ
		    etc.
	-u	User for ambari hosts (default admin)
	-p	Password for ambari users (default admin)
	-n	DNS or IP of ambari hosts (is required params)
	-d	port for ambari service (default 8080)
EOF
}

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

while getopts ":hs:n:u:p:o:" OPTION
do
    case $OPTION in
	h)
        usage
        exit 1
	    ;;
	s) 
	    SERVICE=$OPTARG	
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
output=$(curl -u "$AMBARI_USER:$PASSWORD" -i -H 'X-Requested-By: ambari'  http://"$AMBARI_HOST:$AMBARI_PORT"/api/v1/clusters)
CLUSTER=$(echo "$output" | sed -n 's/.*"cluster_name" : "\([^\"]*\)".*/\1/p')

#run commands
curl -u $AMBARI_USER:$PASSWORD -i -H 'X-Requested-By: ambari' -X DELETE http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER/services/$SERVICE