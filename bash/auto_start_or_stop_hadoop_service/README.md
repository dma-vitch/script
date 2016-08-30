auto_start_or_stop_hadoop_service
---------------------------------

Requirement
------------
- Installed hadoop
- Installed ambari

Install
-------

- Put hadoop-core in `/etc/init.d` on your ambari_host

- Change variable on your
```
$PASSWORD
$CLUSTER_NAME
$AMBARI_HOST
$AMBARI_USER
```

- Set execution on script:

`chmod u+x path-to-script`
 
or
```
chgrp groupname path-to-script
chmod 750 path-to-script
```

- Add Service to the Startup

`
chkconfig --add hadoop-core
`

- Turn-on a Service for a Selected Run Level
`
chkconfig --level 234 hadoop-core on 
`
or 

- Create simlink
```
ln -s /etc/init.d/hadoop-core /etc/rc.d/rc0.d/K03hadoop-core
ln -s /etc/init.d/hadoop-core /etc/rc.d/rc3.d/S97hadoop-core
ln -s /etc/init.d/hadoop-core /etc/rc.d/rc4.d/S97hadoop-core
```