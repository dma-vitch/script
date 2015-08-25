auto_start_or_stop_oracle_bd
----------------------------

Requirement
------------
- Installed oracle database

Install
-------
- Put oraservice.sh in `/etc/init.d` and envoracle.cfg in one any directory

- Change path to envoracle.cfg in script [`oraservice.sh`] (https://github.com/dma-vitch/script/blob/master/bash/auto_start_or_stop_oracle_bd/oraservice.sh)

- Set privelegeus on script:

`chgrp dba user`
`chmod 750 user`

- Create simlink
```
ln -s /etc/init.d/oraservice /etc/rc.d/rc0.d/K01oraservice
ln -s /etc/init.d/oraservice /etc/rc.d/rc3.d/S99oraservice
ln -s /etc/init.d/oraservice /etc/rc.d/rc4.d/S99oraservice
```