/* ���������� ������������*/
select username, account_status from dba_users where ACCOUNT_STATUS LIKE '%EXPIRED%';
/* ������ ���� ��������� �������� ������ */
select username, account_status, to_char(expiry_date, 'DD-MM-YYYY') EXP_DATE from dba_users where username = 'PDB_REPORT'
/*select username, account_status, to_char(expiry_date, 'DD-MM-YYYY') EXP_DATE from dba_users where username LIKE 'PDB%'*/
/* ����������� � ������������� ������*/
/*ALTER USER SORM_NGENIE ACCOUNT UNLOCK;
ALTER USER PDB_REPORT IDENTIFIED BY pdb_report*/
/* ������������� �������� ��� ��������� �������*/
/*ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;*/
/*select * from dba_profiles
select * from profile$
*/
/*
��������� ������� ������� �� ����������� ����� ����� ���� � �� ������� ����� �������
*/
/*
select RESOURCE_NAME,LIMIT FROM dba_profiles
where  PROFILE='DEFAULT' AND RESOURCE_NAME IN ('FAILED_LOGIN_ATTEMPTS','PASSWORD_LOCK_TIME')
*/

