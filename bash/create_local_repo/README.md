create_local_repo_oraclelinux
--------------

Requirement
------------
- Access to internet
- OS Oracle Linux 6.x

Install
-------
- Copy create_local_repo_oraclelinux.sh in directory on your server for example `/opt/scripts/`
- Set executeble for script
`
sudo chmod u+x /opt/scripts/create_local_repo_oraclelinux.sh
`
- Create cron task
`
0 1 * * * /opt/scripts/create_local_repo_oraclelinux.sh > /dev/null 2>&1
`
- Setup the HTTP Server. Install the Apache HTTP servers, start it and make sure it restarts automatically on reboot.
`
sudo yum install httpd
sudo service httpd start
sudo chkconfig httpd on
`
- If you are using the Linux firewall you will need to punch a hole for port 80.
`
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo service iptables save
`
- Either set SELinux to permissive, or configure the fcontext for the repository files as shown below.
`
# # One-off configuration.
sudo yum install policycoreutils-python -y
sudo semanage fcontext -a -t httpd_sys_content_t "/opt/repository/OracleLinux(/.*)?"

# # Run each time the repo contents change.
sudo restorecon -F -R -v /opt/repository/OracleLinux
```
- Present the repositories using the HTTP server.
`
sudo mkdir -p /var/www/html/repo/OracleLinux/OL6/latest
sudo ln -s /repo/OracleLinux/public_ol6_latest/getPackage/ /var/www/html/repo/OracleLinux/OL6/latest/x86_64

sudo mkdir -p /var/www/html/repo/OracleLinux/OL6/UEK/latest
sudo ln -s /repo/OracleLinux/public_ol6_UEK_latest/getPackage/ /var/www/html/repo/OracleLinux/OL6/UEK/latest/x86_64

sudo mkdir -p /var/www/html/repo/OracleLinux/OL6/UEKR3/latest
sudo ln -s /repo/OracleLinux/public_ol6_UEKR3_latest/getPackage/ /var/www/html/repo/OracleLinux/OL6/UEKR3/latest/x86_64
```
Features
---------
- Script for automatic update and create local repository


Usage
-----

./create_local_repo_oraclelinux.sh
