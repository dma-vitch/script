#!/bin/bash
#IFS=,
#mkdir -p /repo/OracleLinux
#mkdir -p /repo/logs
#mkdir -p /repo/scripts

LISTDIR=("/opt/repository/OracleLinux" "/opt/repository/logs")
LOG_FILE=/opt/repository/logs/repo_sync_$(date +%Y.%m.%d).log

# Check exist directory
for i in ${LISTDIR[@]}; do
    if ! [[ -d "$i" ]]; then
        mkdir -p $1
    fi
done

# Remove old logs
find /opt/repository/logs/repo_sync* -mtime +5 -delete; >> $LOG_FILE 2>&1

# Sync repositories
/usr/bin/reposync --repoid=public_ol6_latest --repoid=public_ol6_UEK_latest \
                  --repoid=public_ol6_UEKR3_latest -p /opt/repository/OracleLinux >> $LOG_FILE 2>&1

/usr/bin/createrepo /opt/repository/OracleLinux/public_ol6_latest/getPackage/ >> $LOG_FILE 2>&1
/usr/bin/createrepo /opt/repository/OracleLinux/public_ol6_UEK_latest/getPackage/ >> $LOG_FILE 2>&1
/usr/bin/createrepo /opt/repository/OracleLinux/public_ol6_UEKR3_latest/getPackage/ >> $LOG_FILE 2>&1