CREATE PLUGGABLE DATABASE &1 ADMIN USER &2 identified by "&2"
DEFAULT TABLESPACE USERS
DATAFILE '/opt/u01/app/oracle/oradata/oracle12/&1/users01.dbf'
SIZE 250M AUTOEXTEND ON
FILE_NAME_CONVERT=(
'/opt/u01/app/oracle/oradata/oracle12/pdbseed/',
'/opt/u01/app/oracle/oradata/oracle12/&1/');