--run script from shell 
--sqlplus user/password@db @script.sql [param1, param2,..paramN]
--disable old and new value option in output
set verify off
--Close the clone PDB.
alter pluggable database &1 close immediate;
--Delete the clone PDB and its data files.
drop pluggable database &1 including datafiles;
--Create new PDB
CREATE PLUGGABLE DATABASE &1 FROM &2 FILE_NAME_CONVERT =('&3','&4');
--Open the clone PDB to write
alter pluggable database &1 open;
--exit from sqlplus
exit	