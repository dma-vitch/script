#!/bin/bash
#переменные
EXT_IP="xxx.xxx.xxx.xxx" # Он всё равно чаще всего один и тот же.
INT_IP="xxx.xxx.xxx.xxx" # См. выше.
EXT_IF=eth0 # Внешний и внутренний интерфейсы.
INT_IF=eth1 # Для шлюза они вряд ли изменятся, поэтому можно прописать вручную.
FW_PORT=$1  # Вначале передаём скрипту "неправильный" порт на внешнем интерфейсе,
DST_IP=$2     # затем - локальный адрес сервера
DST_PORT=$3   # и в конце - реальный порт для подключения к серверу
NO_VAR=0
E_OPTERROR=65

if [ $# -eq "$NO_VAR" ]  # Сценарий вызван без переменных?
then
  echo "Порядок использования: `basename $0`  FW_PORT, DST_IP, DST_PORT"
  exit $E_OPTERROR        # Если аргументы отсутствуют -- выход с сообщением
                          # о порядке использования скрипта
fi
#проверка ввода всех аргументов
if [ "$#" -lt 3 ]; then 
  echo "Необходимо ввести все значения аргументов через пробел: FW_PORT DST_IP DST_PORT"
  exit 1
fi

#проверка первого аргумента переадресовываемый порт
if [[ ! "$1" =~ ^[0-9]$ ]]; then 
  echo "Порт должен быть числовым значением"
  exit 1
fi

# Функция проверки правильности IP-адреса:
function valid_ip()
{
  local ip=$1
  local stat=1
#проверяем правильность формы IP
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
#проверяем диапазон актетов IP
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
      && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  return $stat
}
#вызываем функцию
valid_ip $2
if [[ $? -eq 0 ]]; then
  echo "Неправильный формат или диапазон IP"
fi

#проверка  переадресованного порта
if [[ ! "$3" =~ ^[0-9]$ ]]; then 
  echo "Порт должен быть числовым значением"
  exit 1
fi

#Проверка forwarding
fwd=`cat /proc/sys/net/ipv4/conf/eth0/forwarding`
if [[ ! $fwd eq 1 ]]; then 
  echo "Необходимо включить forward, для этого выполните sysctl -w net.ipv4.ip_forward=1"
    exit 1
fi

iptables -t nat -A PREROUTING -d $EXT_IP -p tcp -m tcp --dport $FW_PORT -j DNAT --to-destination $DST_IP:$DST_PORT
iptables -t nat -A POSTROUTING -d $DST_IP -p tcp -m tcp --dport $DST_PORT -j SNAT --to-source $INT_IP
iptables -t nat -A OUTPUT -d $EXT_IP -p tcp -m tcp --dport $DST_PORT -j DNAT --to-destination $DST_IP
iptables -I FORWARD 1 -i $EXT_IF -o $INT_IF -d $DST_IP -p tcp -m tcp --dport $DST_PORT -j ACCEPT
