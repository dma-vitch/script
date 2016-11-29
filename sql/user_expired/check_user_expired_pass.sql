/* Залоченные пользователи*/
select username, account_status from dba_users where ACCOUNT_STATUS LIKE '%EXPIRED%';
/* Узнаем дату окончания действия пароля */
select username, account_status, to_char(expiry_date, 'DD-MM-YYYY') EXP_DATE from dba_users where username = 'PDB_REPORT'
/*select username, account_status, to_char(expiry_date, 'DD-MM-YYYY') EXP_DATE from dba_users where username LIKE 'PDB%'*/
/* Разлочиваем и устанавливаем пароль*/
/*ALTER USER SORM_NGENIE ACCOUNT UNLOCK;
ALTER USER PDB_REPORT IDENTIFIED BY pdb_report*/
/* устанавливаем политику без истечени¤ паролей*/
/*ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;*/
/*select * from dba_profiles
select * from profile$
*/
/*
проверяем сколько попыток не правильного входа может быть и на сколько лочим аккаунт
*/
/*
select RESOURCE_NAME,LIMIT FROM dba_profiles
where  PROFILE='DEFAULT' AND RESOURCE_NAME IN ('FAILED_LOGIN_ATTEMPTS','PASSWORD_LOCK_TIME')
*/
/*
Узнаем пароль*/
/*
select password from dba_users where username = 'PDB_EEST';
*/