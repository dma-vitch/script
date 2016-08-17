#!/bin/bash
#
# reposync Zabbix
#

distrelease=$(rpm -q --qf "%{version}" -f /etc/redhat-release)

if [ ! -f /etc/yum/repos.d/zabbix.repo ]
then
    rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/$distrelease/$(arch)/zabbix-release-3.0-1.el6.noarch.rpm
fi

BASEDIR=/var/www/html/zab
mkdir -p $BASEDIR
cd $BASEDIR
reposync -n -r zabbix
reposync -n -r zabbix-non-supported
repomanage -o -c zabbix | xargs rm -fv
#createrepo zabbix
#createrepo zabbix-non-supported
#update repo
#createrepo --update zabbix
#createrepo --update zabbix-non-supported

chmod -R o-w+r $BASEDIR