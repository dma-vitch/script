bkp_oracle
--------------

Requirement
------------
- Installed oracle database

Install
-------
- Put bkp_oracle.sh and envoracle.cfg in one directory

- Change path to envoracle.cfg in script [`bkp_oracle.sh`] (https://github.com/dma-vitch/script/blob/master/bash/export_oracle_bd/bkp_oracle.sh)

- Change SCHEMAS what you want export

- Change path to your backup directory

- Add cron task for user oracle
`
crontab -e 
` 
and insert property for cron task

`
00 3 * * * /bin/bash /home/oracle/script/bkp_oracle.sh bdname
`

Features
---------

- Script for export schemas on oracle database

Usage
-----
`
./bkp_oracle.sh bdname host port
`