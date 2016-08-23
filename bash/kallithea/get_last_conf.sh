#!/bin/bash

# Define Kallitea Configuration
KALLITHEA_BASE=http://192.168.58.114/hg
LOGIN_PATH=/_admin/login?

usage()
{
cat <<EOF
usage: $0 options
This script will fetch an config from a Kalitea server using the API.
OPTIONS:
  -h    Show this message
  -a    PN coordinate path:nameID
  -e    Artifact extensions
  -b    Branch of repo (login and password in .hgrc)
  -o    Output file
  -r	Repository
  -u    Username
  -p	Password
  -k    Kallithea Base URL
  -z    if Kallitea has newer version of artifact, remove Output File and exit.

  Example: ./get_last_conf.sh -s Project -r project-test -a conf:project-test-config -e conf
EOF
}

# Read in Complete Set of Coordinates from the Command Line
PATH_ID=
NAME_ID=
EXTENSIONS=xls
REPO=
USERNAME=
PASSWORD=
OUTPUT=
BRANCH=default

while getopts "ha:b:e:s:o:r:u:p:k:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        a)
            OIFS=$IFS
            IFS=":"
            PN_COORD=( $OPTARG )
            PATH_ID=${PN_COORD[0]}
            NAME_ID=${PN_COORD[1]}
            #VERSION=${PN_COORD[2]}
            IFS=$OIFS
            ;;
        b)
            BRANCH=$OPTARG
            ;;
        e)
            EXTENSIONS=$OPTARG
            ;;
		s)
            SCHEME=$OPTARG
            ;;
        o)
            OUTPUT=$OPTARG
            ;;
        r)
            REPO=$OPTARG
            ;;
        u)
            USERNAME=$OPTARG
            ;;
        p)
            PASSWORD=$OPTARG
            ;;
		k)
            KALLITHEA_BASE=$OPTARG
            ;;
        #z)
          #  SNAPSHOT_CHECK=1
          #  ;;
        ?)
            echo "Illegal argument $OPTION=$OPTARG" >&2
            usage
            exit
            ;;
    esac
done

if [[ -z $PATH_ID ]] || [[ -z $NAME_ID ]]
then
    echo "BAD ARGUMENTS: Either pathId or nameId was not supplied" >&2
    usage
    exit 1
fi

if [[ "$SCHEME" != "" ]]
then
    SCHEME="/$SCHEME"
fi

#config get last commit
VERSION=$(hg identify --id --rev $BRANCH ${KALLITHEA_BASE}${SCHEME}/${REPO})

# Generate the list of parameters
#PARAM_KEYS=( r g a v p c )
#PARAM_VALUES=( $REPO $GROUP_ID $ARTIFACT_ID $VERSION $EXTENSIONS $CLASSIFIER )
#PARAMS=""
#for index in ${!PARAM_KEYS[*]}
#do
#  if [[ ${PARAM_VALUES[$index]} != "" ]]
#  then
#    PARAMS="${PARAMS}${PARAM_KEYS[$index]}=${PARAM_VALUES[$index]}&"
#  fi
#done


# Construct the base URLs
LOGIN_URL=${KALLITHEA_BASE}${LOGIN_PATH}
DOWNLOAD_URL=${KALLITHEA_BASE}${SCHEME}/${REPO}

# Authentication
AUTHENTICATION=
if [[ "$USERNAME" != "" ]]  && [[ "$PASSWORD" != "" ]]
then
    AUTHENTICATION="--data "username=$USERNAME\&password=$PASSWORD""
fi

# Output
OUT="-o ${NAME_ID}.${EXTENSIONS}"
if [[ "$OUTPUT" != "" ]]
then
    OUT="-o $OUTPUT"
fi

curl -sS -L --cookie-jar cookies.txt $AUTHENTICATION "$LOGIN_URL" >>/dev/null
#curl -sS -L --cookie-jar cookies.txt --data "username=$USERNAME&password=$PASSWORD" "$LOGIN_URL" >>/dev/null
echo "Fetching Artifact from ${DOWNLOAD_URL}/raw/${VERSION}/${PATH_ID}..." >&2
curl -sS -L --cookie cookies.txt ${DOWNLOAD_URL}/raw/${VERSION}/${PATH_ID}/${NAME_ID}.${EXTENSIONS} ${OUT}
