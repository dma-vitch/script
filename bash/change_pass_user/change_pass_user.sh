#!/bin/bash
read -p "Enter Username: " username
read -ers -p "Enter New password for user $username: " paswd
echo
read -ers -p "Enter Root Password: " rpaswd
echo
password=`python filecryp ${paswd}`;
echo "$username $password $npaswd"
cat host | while read line
do
#####expect####
status=$(expect -c "
spawn ssh $line usermod -p $password $username
expect {
password: { send \"$rpaswd\n\"; exp_continue }
}
exit
")
echo ""
echo "$status" > log.txt
#####end of expect#######
done