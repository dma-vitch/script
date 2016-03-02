@echo off
chcp 1251
set IFACE="����������� �� ��������� ���� 2"
set DNS1=10.189.132.11
set DNS2=8.8.8.8
set RIP1=10.189.128.0
set RIP2=192.168.58.0
set RIP3=10.189.132.0
set RIP4=10.188.46.0
set RMASK=255.255.255.0
set GATEWAY=10.189.128.1
set GWMETRIC=1

echo ����������� ���������� �������� ��� �����: %RIP1% %RIP2% %RIP3%

route ADD -p %RIP1% MASK %RMASK% %GATEWAY% METRIC %GWMETRIC%
route ADD -p %RIP2% MASK %RMASK% %GATEWAY% METRIC %GWMETRIC%
route ADD -p %RIP3% MASK %RMASK% %GATEWAY% METRIC %GWMETRIC%
route ADD -p %RIP4% MASK %RMASK% %GATEWAY% METRIC %GWMETRIC%

rem netsh interface ip set dns "����������� �� ��������� ���� 2" static 10.189.132.11 primary
rem netsh interface ip add dns "����������� �� ��������� ���� 2" 8.8.8.8 index=2
rem netsh interface ip set address %IFACE% static %IP% %MASK% %GATEWAY% %GWMETRIC%

rem echo ����������� ��������� ����: 
rem echo IP-�����: %IP%
rem echo ����� �������: %MASK%
rem echo �������� ����: %GATEWAY%

echo �������������� DNS ������: %DNS1%
netsh interface ip set dns %IFACE% static %DNS1% primary
echo �������������� DNS ������: %DNS2%
netsh interface ip add dns %IFACE% %DNS2% index=2