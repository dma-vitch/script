#!/bin/bash

TIME=`date +%Y-%b`
BK_DIR=/var/backups/foswiki/
creditFile=credits.ini

#crypt ypy files
#GPG_COMMAND="gpg -c -z 0 --batch --passphrase XXXXXXXXXX"

#check credit file
if [ ! -f $creditFile ]; then
        echo "please fill $creditFile (file has just been created)"
        echo "username=$login
password=$pass">$creditFile
        exit 1
fi

f=`find $BK_DIR -mtime 0 -name *.tar.gz`
echo "upload this files $f" > /tmp/yanlog.upload.txt
. credits.ini

#MYSQL_FILE=/tmp/$-mysql.$TIME.sql.gz

# Archiving databases
#mysqldump -u root --password=qwerty --all-databases | gzip > $MYSQL_FILE

for file in $f
do
# Uploading to the cloud
mime_type=`file --brief --mime-type "$file"`
curl -Sv -k --user $username:"$password" -H "Content-Type: $mime_type" -T "$file" https://webdav.yandex.ru/123/ >> /tmp/yanlog.upload.txt
done
