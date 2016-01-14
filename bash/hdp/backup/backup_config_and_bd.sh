#!/bin/bash
# Backup all configurations from /etc directory and any sql databases being used by Hive, Oozie, 
# HUE, Ambari.
# This can be run by root user under its home directory or any user that has root privileges.
# This script will create the backup files in the current directory and later move it to HDFS for snapshotting and backup/DR.

#param
now=$(date +'%Y-%m-%d')
RED="\033[1;31m"
NORMAL="\033[0m\n"
E_BADARGS=65

#Block service function
function usage {
cat <<EOF
Usage: `basename $0` [arg1 arg2 etc]

This script will backup  hadoop services configurations.

ARGUMENTS:
	conf or configurations	exec function of backup configurations
	hue						exec function of backup hue database
	hive					exec function of backup hive database
	oozie					exec function of backup oozie database
	ambari					exec function of backup ambari database
	all						Backup all services
	
EOF
}

#Create TAR file of the /etc directory and its subdirectories
function bkp_conf {
echo "......creating TAR file for /etc and children" + $(date)
tar --create --gzip --preserve-permissions --recursion --absolute-names -f $now.etc.hadoop.conf.tar.gz /etc/hadoop/conf/
echo "......finished creating the TAR file with filename etc.hadoop.conf.tar.gz " + $(date)
# Push the TAR file to HDFS
echo "......saving etc.hadoop.conf.tar.gz TAR file to HDFS" + $(date)
hadoop fs -put $now.etc.hadoop.conf.tar.gz /etc_backup
echo "......TAR file saved to HDFS " + $(date)
}
#TAR the HUE desktop.db database image and save it to HDFS. Run this step where HUE database is located.
function bkp_hue {
echo "......creating TAR file for HUE's desktop.db database" + $(date)
tar --create --gzip --preserve-permissions --recursion --absolute-names -f $now.hue.desktop.db.tar.gz /var/lib/hue/desktop.db
echo "......saving hue.desktop.db.tar.gz to HDFS"
# Push the TAR file to HDFS
hadoop fs -put $now.hue.desktop.db.tar.gz /sql_dbs_backup
echo "......finished saving hue.desktop.db.tar.gz to HDFS " + $(date)
}

#Create the Hive metastore database dumps and save it to HDFS. You need to set hostname on where mysql is installed.
function bkp_hive {
echo "......creating TAR file for Hive's metastore database " + $(date)
mysqldump -h hostname -u hive -phive --add-drop-database --add-drop-table --complete-insert --create-options --debug-check --dump-date --events --extended-insert --flush-privileges --lock-all-tables --log-error=hive_dump.error --databases hive > $now.hive_metastore.sql
echo "......finished creating Hive metastore backup " + $(date)
echo "......saving hive metastore db file to HDFS" + $(date)
hadoop fs -put $now.hive_metastore.sql /sql_dbs_backup
echo "......finished saving hive metastore db file to HDFS" + $(date)
}

#At this step, it is assumed that the root home directory has a file called .pgpass and its owned by root and has a permission of 600. Their should only be one line in that file which has -> hostname:5432:ambari:ambari:bigdata
function bkp_ambari {
echo "......performing back up of PostgreSQL database for Ambari " + $(date)
pg_dump --host=hostname -U ambari  --file=$now.ambari.postgresql.backup
echo "......finished backing up Ambari PostgreSQL database " + $(date) 
echo "......saving ambari.postgresql.backup to HDFS " + $(date) 
hadoop fs -put $now.ambari.postgresql.backup /sql_dbs_backup
echo "......finished saving ambari.postgresql.backup to HDFS" + $(date) 
}

#Backup Oozie Derby database and load it up to HDFS for snapshotting and backup/Dr purposes. Run this script where database is located.
function bkp_oozie {
echo "......creating TAR file for Oozie derby database" + $(date)
tar --create --gzip --preserve-permissions --recursion --absolute-names -f $now.oozie.derby.tar.gz /hadoop/oozie/data/
echo "......finished creating the TAR file with filename oozie.derby.tar.gz " + $(date)
echo "......saving oozie.derby.tar.gz TAR file to HDFS" + $(date)
hadoop fs -put $now.oozie.derby.tar.gz /sql_dbs_backup
echo "......finished saving oozie.derby.tar.gz to HDFS " + $(date)
}

#Clean up locally created temporarily backup files since they're already in HDFS at this point.
function clean {
echo "......cleaning up locally created temporary backup files" + $(date)
rm -f $now.*
echo "......finished cleaning up locally created temporary backup files" + $(date)
}

#check count arguments
if [[ -z "$@"]]
then
	printf "$RED Wrong arguments for running $NORMAL \n" >&2
	usage
exit $E_BADARGS
fi

# selection args and actions
for i in $@
do
	case $i in
		conf|configurations)
			bkp_conf
		;;
		hue) 
			bkp_hue
		;;
		hive)
			bkp_hive
		;;	
		ambari)
			bkp_ambari
		;;	
		oozie)
			bkp_oozie
		;;
		all)
			bkp_conf
			bkp_hue
			bkp_hive
			bkp_ambari
			bkp_oozie
		;;	
		*) 
			printf "$RED Wrong arguments for running, please check this "$i" argument, but script execute contining $NORMAL \n" >&2
		;;
	esac

done

#delete tempory
clean

exit 0
