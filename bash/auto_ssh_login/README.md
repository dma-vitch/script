auto_ssh_login
--------------

Requirement
------------
- Instaled expect

Install
-------
- If you are using Debian/Ubuntu Linux then use apt-get as follows :

`
sudo apt-get install expect expectk
` 
- For Fedora core (RHEL 5,6,7) / CentOS Linux user can use yum:

`
yum install expect expectk
`
- You can use ports to install expect under FreeBSD or use following command:

`
pkg_add -v -r expect
`

Features
---------

- Script for automatic insert password for ssh-session and doing remote command

Usage
-----

./sshauto.sh "df -h"