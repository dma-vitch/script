#!/bin/bash
echo -n "Password:"
read -s passw; echo
stty echo
while read IP
do
./sshlogin.exp $passw $IP "$1" 2> /dev/null
done < ip_addresses.txt
# for faster excute
#Z=10
#cat ip_addresses.txt | xargs -l1 -I\1 -P${Z} ./sshlogin.exp $passw \1 "$1"
