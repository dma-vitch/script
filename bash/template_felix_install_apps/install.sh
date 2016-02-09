#!/bin/bash
#params
RED="\033[1;31m"
GREEN="\033[1;32m"
NORMAL="\033[0m\n"

#apps-из конфига

function usage {
cat <<EOF
Usage: `basename $0` [options]

This script will install apps,java and create users

OPTIONS:
	-h 	Show help message
	-s	silent mode
	
EOF
}

#common function
function getpath {
# Full path to script/полный путь до скрипта
local ABSOLUTE_FILENAME=`readlink -e "$0"`
# /dir of script /каталог в котором лежит скрипт
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`
}

getpath
#load config/подгружаем конфиг файл
if [ -s "$DIRECTORY/config.cfg" ]; then
    source $DIRECTORY/config.cfg
else
    printf "$RED ERROR: file config.cfg not exist $NORMAL" >&2
    exit 1
fi
            
function check_var {
if [ -z $OWNER || -z $apps ] ; then 
    printf "$RED Any reqired options not found in config.cfg: $NORMAL" >&2 ;
    exit 1
fi
}

function error {
if [ $? -ne 0 ] ; then
    printf "$RED ERROR please check logfile for details $NORMAL" >&2 ;
    exit 1
else
    printf "$GREEN SUCCESSFUL $NORMAL" >&1 ;
    rm -f $LOGFILE
fi
}

function arh {
#get arhitecture of pc/определяем разрядность ОС
printf "Define architecture of your OS\n"
if [ "`uname -m`" = "x86_64" ] ; then
    #echo -e "Your OS is 64 bit"
    ARCH=64
else
    #echo -e "Your OS is 32 bit"
    ARCH=32
fi
}

function check_wget_ver {
# check if wget version is 1.16 or higher
local V_WGET=$(wget --version | head -1 | cut -d' ' -f3)
# set progress option accordingly
[ $(printf "${V_WGET}\n1.16" | sort -V | head -1) = 1.16 ] && \
W_PROGRESS_OPT="-q --show-progress" || W_PROGRESS_OPT=""
}

#usability function
function getdistr {
local APPNAME=$apps
local IFS=",";
check_wget_ver
for item in $APPNAME
do
    case $item in
	loot)
	    printf "$GREEN download loot3, apps versions "$version" $NORMAL \n" >&1
	    wget $W_PROGRESS_OPT -c -P $DIRECTORY http://example.com/felix-loot-$version.zip
	    ;;
	extractor)
	    printf "$GREEN download loot3-extractor, apps versions "$version" $NORMAL \n" >&1
	    wget $W_PROGRESS_OPT -c -P $DIRECTORY http://example.com/felix-loot-extractor-$version
	    ;;
	entitybuild)
	    printf "$GREEN download loot3-entitybuild, apps versions "$version" $NORMAL \n" >&1
	    wget $W_PROGRESS_OPT -c -P $DIRECTORY http://example.com/felix-loot-entitybuild-$version.zip	
	    ;;
	\?)
	    printf "$RED Unknown apps "$item" $NORMAL \n" >&2
	    return 1
	    ;;
    esac
done	
}

function extract {
local APPNAME=$apps
#local IFSORIG="$IFS";
#change separator /изменяем разделитель
local IFS=",";
for item in $APPNAME
do
#	tar zxf $DIRECTORY/loot*.tgz -C /opt/
    case $item in
	loot)
	    unzip $DIRECTORY/felix-loot-$vLOOT.zip -d /opt/ >> $LOGFILE 2>&1
	    sleep 1
	    find /opt/felix-loot-$vLOOT -type f \( -name '*.sh' -o -name '*.jar' \) -exec chmod 0750 {} \;
	    #rm -f $DIRECTORY/felix-loot-$vLOOT.zip
	    ;;
	extractor)
	    unzip $DIRECTORY/felix-loot-extractor-$vEXTRACT.zip -d /opt/ >> $LOGFILE 2>&1
	    sleep 1
	    rm -f $DIRECTORY/felix-loot-extractor-$vEXTRACT.zip
	    ;;
	entitybuild)
	    unzip $DIRECTORY/felix-loot-entitybuild-$vENTITY.zip -d /opt/ >> $LOGFILE 2>&1
	    sleep 1
	    rm -f $DIRECTORY/felix-loot-entitybuild-$vENTITY.zip
	    ;;
	\?)
	    printf "$RED Unknown apps "$APPNAME" $NORMAL \n" >&2
	    return 1
	    ;;
    esac
done
}

getpath

#load config/подгружаем конфиг файл
if [ -s "$DIRECTORY/config.cfg" ]; then
    source $DIRECTORY/config.cfg
else
    printf "$RED ERROR: file config.cfg not exist $NORMAL" >&2
    exit 1
fi

function regserv {
local APPNAME=$apps
#local IFSORIG="$IFS";
#change separator /изменяем разделитель
local IFS=",";
for item in $APPNAME
do
    case $item in
	loot)
	    ln -s /opt/felix-loot-$vLOOT/felix-loot -d /etc/init.d/felix-loot >> $LOGFILE 2>&1
	    sleep 1
	    chkconfig --add felix-loot >> $LOGFILE 2>&1
	    chkconfig --level 2345 felix-loot on >> $LOGFILE 2>&1
	    #rm -f $DIRECTORY/felix-loot-$vLOOT.zip
	    ;;
	extractor)
	    ln -s /opt/felix-extractor-$vEXTRACT/felix-loot-extractor -d /etc/init.d/felix-loot-extractor >> $LOGFILE 2>&1
	    sleep 1
	    chkconfig --add felix-loot-extractor >> $LOGFILE 2>&1
	    chkconfig --level 2345 felix-loot-extractor on >> $LOGFILE 2>&1
	    ;;
	entitybuild)
	    ln -s /opt/felix-loot-entitybuild-$vENTITY/felix-loot-entitybuild /etc/init.d/felix-loot-entitybuild>> $LOGFILE 2>&1
	    sleep 1 
	    chkconfig --add felix-loot-entitybuild >> $LOGFILE 2>&1
	    chkconfig --level 2345 felix-loot-entitybuild on >> $LOGFILE 2>&1
	    ;;
	\?)
	    printf "$RED Unknown apps "$item" $NORMAL \n" >&2
	    return 1
	    ;;
    esac
done
}

function cruser {
grep "$OWNER:" /etc/passwd >/dev/null
if [ $? -ne 0 ]; then
#if [ ! "$(id -nu)" == "$OWNER" ]; then
	echo "Create user: "$OWNER" for apps"
	adduser -m -d /home/$OWNER -c user for loot -s /bin/bash
	#sleep 1
#else
#echo "OK" 
fi 
}

function own {
local APPNAME=$apps
#local IFSORIG="$IFS";
#change separator /изменяем разделитель
local IFS=",";
for item in $APPNAME
do
    case $item in
	loot)
	    chown -R $OWNER /opt/felix-loot-$vLOOT >> $LOGFILE 2>&1
	    ;;
	extractor)
	    chown -R $OWNER /opt/felix-loot-extractor-$vEXTRACT >> $LOGFILE 2>&1
	    ;;
	entitybuild)
	    chown -R $OWNER /opt/felix-loot-entitybuild-$vENTITY >> $LOGFILE 2>&1
	    ;;
    esac
done
}

#update todo
#delete todo

function java_install {
check_wget_ver
#case java arch to download
if [ $ARCH = 32 ];  then
    local A_JAVA=i586
else
    local A_JAVA=x64
fi

if [[ ! -e $DIRECTORY/jdk-8u66-linux-$A_JAVA.tar.gz ]]; then
    printf "$GREEN Download java version 1.8.0_66 architecture $A_JAVA $NORMAL" >&1 ;

    wget $W_PROGRESS_OPT -P $DIRECTORY --no-cookies --no-check-certificate \
--header "Cookie: oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-$A_JAVA.tar.gz"
else
    printf "$GREEN Install java version 1.8.0_66 $NORMAL" >&1 ;
    mkdir -p /opt/java
    tar xfz $DIRECTORY/jdk-8u66-linux-$A_JAVA.tar.gz -C /opt/java/ >> $LOGFILE 2>&1
	if [ $? -ne 0 ] ; then
	    return 1
	else
#set alternatives
	    alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_66/bin/java 2 >> $LOGFILE 2>&1
	    alternatives --install /usr/bin/jar jar /opt/java/jdk1.8.0_66/bin/jar 2 >> $LOGFILE 2>&1
	    alternatives --install /usr/bin/javac javac /opt/java/jdk1.8.0_66/bin/javac 2 >> $LOGFILE 2>&1
	    alternatives --set java /opt/java/jdk1.8.0_66/bin/java >> $LOGFILE 2>&1
	    alternatives --set jar /opt/java/jdk1.8.0_66/bin/jar >> $LOGFILE 2>&1
	    alternatives --set javac /opt/java/jdk1.8.0_66/bin/javac >> $LOGFILE 2>&1

	    printf "$GREEN JAVA install in /opt/java/jdk1.8.0_66 $NORMAL" >&1 ;
	fi
fi
}

LOGFILE=$DIRECTORY/errors.log

function menu {
#main Bash Menu
PS3='Please enter your choice: '
options=("Download apps" "Install JAVA" "Install apps" "Update apps" "Quit")
select opt in "${options[@]}"
do
    case $opt in
	"Download apps")
	    getdistr
	    ;;
	"Install JAVA")
	    arh && install_java || error
	    error
	    ;;  
    "Install apps")
        check_var && extract && cruser && own && regserv || error
	    error
	    ;;
    "Update apps")
        echo "not working now - developing"
	    ;;
    "Quit")
	    break
        ;;
    *)  echo "invalid option"
	    ;;
    esac
done
}

#check arg count
if [ "$#" -ne 1 ] && [ "$#" -ne 0 ]; then
    usage
fi

#check input args
if [ "$1" = "-h" ]; then
    usage
elif
    [ "$1" = "-s" ]; then
    arh && java_install && check_var && extract && cruser && own && regserv || error
    error
else
    printf "$GREEN  Install menu $NORMAL" >&1 ;
    menu
fi
