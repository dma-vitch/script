#!/bin/bash

function getpath {
# Full path to script/полный путь до скрипта
local ABSOLUTE_FILENAME=`readlink -e "$0"`
# /dir of script /каталог в котором лежит скрипт
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`
}

JAVA="/opt/jdk-8u66/jdk1.8.0_66/"

# Which java to use
#if [ -z "$JAVA_HOME" ]; then
#  JAVA="java"
#  else
#    JAVA="$JAVA_HOME/bin/java"
#fi

function v_java {
if type -p java; then
#    echo found java executable in PATH
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
#    echo found java executable in JAVA_HOME     
    _java="$JAVA_HOME/bin/java"
else
    echo "no java"
fi
                    
if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
#    echo version "$version"
    if [[ "$version" > "1.8" ]]; then
#       echo version is more than 1.8
	JAVA_PATH=""
    else         
#        echo version is less than 1.8
	JAVA_PATH="-java-home $JAVA"
    fi
fi
}

getpath
v_java

echo $JAVA_PATH

$DIRECTORY/bin/kafka-manager $JAVA_PATH -J-Xms128M -J-Xmx512m -J-server