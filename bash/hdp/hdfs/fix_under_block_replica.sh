﻿#!/bin/bash
su - hdfs 
hdfs fsck / | grep 'Under replicated' | awk -F':' '{print $1}' >> /tmp/under_replicated_files 
for hdfsfile in `cat /tmp/under_replicated_files`; do echo "Fixing $hdfsfile :" ; hadoop fs -setrep 3 $hdfsfile; done
