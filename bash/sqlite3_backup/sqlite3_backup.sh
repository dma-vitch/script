#!/bin/bash
#
# sqlite3_backup.sh
# Script for backing up sqlite3 database with integrity checking
# Intended for use with cron for regular automated backups
#

DB="/path/to/file.db"
BKUP_PATH="/path/to/backup/dir"
LOG="/path/to/backup.log"

# check to see if $DB exists
if [ ! -f $DB ]
then
    echo $(date +"%Y-%m-%d %T") -- cannot find the database at the following path: $DB >> $LOG
    exit 1
fi

# check to make sure $BKUP_PATH exists and is writable
if [ ! -d $BKUP_PATH ]
then
	# BKUP_PATH does not exist or is not a directory
    echo $(date +"%Y-%m-%d %T") -- cannot find backup path: $BKUP_PATH >> $LOG
    exit 1
else
	# check to make sure it's writable
	if [ ! -w $DB ]
	then
		echo $(date +"%Y-%m-%d %T") -- BKUP Path is not writable: $BKUP_PATH >> $LOG
		exit 1
	fi
fi

# check to see if md5 file exists
if [ ! -f $BKUP_PATH/$(basename $DB).md5 ]
then
    # md5 file does not exist
    # create md5 of DB and store it in BKUP_PATH
    md5sum $DB > $BKUP_PATH/$(basename $DB).md5
    exit 1
fi

# compare md5 file and DB md5
md5sum --status -c $BKUP_PATH/$(basename $DB).md5
match=$?

if [ $match -ne 0 ]; then
	# if different, do integrity check to make sure it hasn't been corrupted
	echo -ne $(date +"%Y-%m-%d %T --")" " >> $LOG
	sqlite3 -line $DB 'pragma integrity_check;' >> $LOG
	has_integrity=$?
	if [ $has_integrity -eq 0 ]; then
		# overwrite db file and make new checksum
		md5sum $DB > $BKUP_PATH/$(basename $DB).md5
		cp $DB $BKUP_PATH/$(basename $DB).bk
		copied=$?
		if [ $copied -ne 0 ]; then
			#failed to copy
			echo $(date +"%Y-%m-%d %T") -- Error writing backup file to $BKUP_PATH/$(basename $DB).bk >> $LOG
			exit 1
		fi
		echo $(date +"%Y-%m-%d %T") -- $DB has changed! Backup successful. >> $LOG
		exit 0
	else 
		# db is corrupt
		echo $(date +"%Y-%m-%d %T") -- $DB IS CORRUPT! Backup not overwritten. >> $LOG
		exit 1
	fi
fi