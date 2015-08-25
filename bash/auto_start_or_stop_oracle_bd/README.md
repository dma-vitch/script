auto_start_or_stop_oracle_bd
----------------------------

Requirement
------------
- Installed oracle database

Install
-------
- Put oraservice.sh in `/etc/init.d` and envoracle.cfg in one any directory

- Change path to envoracle.cfg in script [`oraservice`] (https://github.com/dma-vitch/script/blob/master/bash/auto_start_or_stop_oracle_bd/oraservice)

- Set execution on script:

`chmod u+x path-to-script`
 
or
```
chgrp groupname path-to-script
chmod 750 path-to-script
```

- Add Service to the Startup

`
chkconfig --add oraservice
`

- Turn-on a Service for a Selected Run Level
`
chkconfig --level 234 oraservice on 
`
or 

- Create simlink
```
ln -s /etc/init.d/oraservice /etc/rc.d/rc0.d/K01oraservice
ln -s /etc/init.d/oraservice /etc/rc.d/rc3.d/S99oraservice
ln -s /etc/init.d/oraservice /etc/rc.d/rc4.d/S99oraservice
```