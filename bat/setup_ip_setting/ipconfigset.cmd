@echo off
chcp 1251
set /p settings="Выберите настройки (1 - дом, 2 - работа):"
echo Выбраны настройки - %settings%

if %settings% equ 2 goto work

:home
set IFACE="Подключение по локальной сети"
set IP=172.30.0.100
set MASK=255.255.255.0
set GATEWAY=172.30.0.1
set GWMETRIC=1
set DNS1=172.30.0.2
set DNS2=172.30.0.3
goto dalee

:work
set IFACE="Подключение по локальной сети"
set IP=192.168.254.100
set MASK=255.255.255.0
set GATEWAY=192.168.254.1
set GWMETRIC=1
set DNS1=192.168.254.1
set DNS2=192.168.254.2
goto dalee

:dalee
echo Установлены настройки сети: 
echo IP-адрес: %IP%
echo Маска подсети: %MASK%
echo Основной шлюз: %GATEWAY%

netsh interface ip set address %IFACE% static %IP% %MASK% %GATEWAY% %GWMETRIC%
echo Предпочитаемый DNS сервер: %DNS1%
netsh interface ip set dns %IFACE% static %DNS1% primary
echo Альтернативный DNS сервер: %DNS2%
netsh interface ip add dns %IFACE% %DNS2% index=2

set /p ipinfo="Показать настройки сети? (y - да, n - нет):"
echo Текущие настройки сети: %ipinfo%

if %ipinfo% equ n goto ipdontshow

:ipshow
ipconfig /all
goto dalee2

:ipdontshow
echo Отмена показа настроек сети.

:dalee2
pause