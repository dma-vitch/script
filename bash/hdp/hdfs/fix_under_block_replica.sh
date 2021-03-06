﻿#!/bin/bash
#su - hdfs
#Usage sudo -u hdfs ./fix_under_block_replica.sh
replica=${1:-3}

hdfs hdfs fsck / | grep 'Under replicated' | awk -F':' '{print $1}' >> /tmp/under_replicated_files
for hdfsfile in `cat /tmp/under_replicated_files`
do
    echo "Fixing $hdfsfile :" hadoop fs -setrep $replica $hdfsfile
done
