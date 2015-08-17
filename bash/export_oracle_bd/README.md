bkp_oracle
--------------

Requirement
------------
- Instaled oracle database

Install
-------
- Put bkp_oracle.sh and envoracle.cfg in directory

- Add cron task for user oracle
`
crontab -e 
` 
and insert property for cron task

`
00 3 * * * /bin/bash /home/oracle/bkp_oracle.sh
`

Features
---------

- Script for export schemas on oracle database

Usage
-----
`
./bkp_oracle.sh bdname host port
`