#!/bin/bash

function usage {
cat <<EOF
Usage: `basename $0` [options]

This script will backups all configs for services.

OPTIONS:
    -h 	Show help message
    -u	User for ambari hosts (default admin)
    -p	Password for ambari users (default admin)
    -n	DNS or IP of ambari hosts (default hostname of run host)
    -d	port for ambari service (default 8080)
EOF
}

#default params for script
AMBARI_HOST=`hostname -f`
AMBARI_USER=admin
AMBARI_PASSWORD=admin
AMBARI_PORT=8080
timeNow=`date +%Y%m%d_%H%M%S`
RESULT_DIR=/tmp/migrationHDP/configs.sh/$timeNow

#if [ -z $* ]
#    then
#        printf "$RED No options found! $NORMAL \n" >&2
#        usage
#    exit 1
#fi
		    
while getopts ":hn:u:p:" OPTION
do
    case $OPTION in
    h)
        usage
        exit 1
        ;;
    u)
        AMBARI_USER=$OPTARG
        ;;
    p)
        AMBARI_PASSWORD=$OPTARG
		;;
    n)
		AMBARI_HOST=$OPTARG
		;;	
    d)
        AMBARI_PORT=$OPTARG
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

output=`curl -u $AMBARI_USER:$AMBARI_PASSWORD -i -H 'X-Requested-By: ambari' http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters`
CLUSTER_NAME=`echo $output | sed -n 's/.*"cluster_name" : "\([^\"]*\)".*/\1/p'`
mkdir -p $RESULT_DIR

for CONFIG_TYPE in `curl -s -u $AMBARI_USER:$AMBARI_PASSWORD http://$AMBARI_HOST:$AMBARI_PORT/api/v1/clusters/$CLUSTER_NAME/?fields=Clusters/desired_configs \
| grep '" : {' | grep -v Clusters | grep -v desired_configs | cut -d'"' -f2`; do
echo "backuping $CONFIG_TYPE" 
/var/lib/ambari-server/resources/scripts/configs.sh -u $AMBARI_USER -p $AMBARI_PASSWORD -port $AMBARI_PORT get $AMBARI_HOST $CLUSTER_NAME $CONFIG_TYPE \
| grep '^"' | grep -v '^"properties" : {' > $RESULT_DIR/$CONFIG_TYPE.conf
done
