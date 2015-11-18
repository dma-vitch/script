#!/bin/bash
#����������
EXT_IP="xxx.xxx.xxx.xxx" # �� �� ����� ���� ����� ���� � ��� ��.
INT_IP="xxx.xxx.xxx.xxx" # ��. ����.
EXT_IF=eth0 # ������� � ���������� ����������.
INT_IF=eth1 # ��� ����� ��� ���� �� ���������, ������� ����� ��������� �������.
FW_PORT=$1  # ������� ������� ������� "������������" ���� �� ������� ����������,
DST_IP=$2     # ����� - ��������� ����� �������
DST_PORT=$3   # � � ����� - �������� ���� ��� ����������� � �������
NO_VAR=0
E_OPTERROR=65

if [ $# -eq "$NO_VAR" ]  # �������� ������ ��� ����������?
then
  echo "������� �������������: `basename $0`  FW_PORT, DST_IP, DST_PORT"
  exit $E_OPTERROR        # ���� ��������� ����������� -- ����� � ����������
                          # � ������� ������������� �������
fi
#�������� ����� ���� ����������
if [ "$#" -lt 3 ]; then 
  echo "���������� ������ ��� �������� ���������� ����� ������: FW_PORT DST_IP DST_PORT"
  exit 1
fi

#�������� ������� ��������� ������������������ ����
if [[ ! "$1" =~ ^[0-9]$ ]]; then 
  echo "���� ������ ���� �������� ���������"
  exit 1
fi

# ������� �������� ������������ IP-������:
function valid_ip()
{
  local ip=$1
  local stat=1
#��������� ������������ ����� IP
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
#��������� �������� ������� IP
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
      && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  return $stat
}
#�������� �������
valid_ip $2
if [[ $? -eq 0 ]]; then
  echo "������������ ������ ��� �������� IP"
fi

#��������  ����������������� �����
if [[ ! "$3" =~ ^[0-9]$ ]]; then 
  echo "���� ������ ���� �������� ���������"
  exit 1
fi

#�������� forwarding
fwd=`cat /proc/sys/net/ipv4/conf/eth0/forwarding`
if [[ ! $fwd eq 1 ]]; then 
  echo "���������� �������� forward, ��� ����� ��������� sysctl -w net.ipv4.ip_forward=1"
    exit 1
fi

iptables -t nat -A PREROUTING -d $EXT_IP -p tcp -m tcp --dport $FW_PORT -j DNAT --to-destination $DST_IP:$DST_PORT
iptables -t nat -A POSTROUTING -d $DST_IP -p tcp -m tcp --dport $DST_PORT -j SNAT --to-source $INT_IP
iptables -t nat -A OUTPUT -d $EXT_IP -p tcp -m tcp --dport $DST_PORT -j DNAT --to-destination $DST_IP
iptables -I FORWARD 1 -i $EXT_IF -o $INT_IF -d $DST_IP -p tcp -m tcp --dport $DST_PORT -j ACCEPT
