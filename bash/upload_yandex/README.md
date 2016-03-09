upload_yandex
-------------

Requirement
------------

-Install curl

Features
---------
Upload files in yandex disk

Usage
-----

- Set your variables in:
```
BK_DIR - path to files for upload 
creditFile - name of file for autentification
```
- In creditFile you fill your credit for access to yandex disk:
```
username=login
password=pass
```
- If you want upload into define directory, you will change this string
` 
https://webdav.yandex.ru/{directory}
`

second way

- mount yandex disc into system
- install davfs2

`
apt-get install davfs2
`
- Create autentification file
`
echo "/mnt/yandex.disk username \"password\"" > /etc/davfs2/secrets
`
- change permission
```
chmod 0600 /etc/davfs2/secrets
echo "y" > /etc/davfs2/dav.inp
chmod 0700 /etc/init.d/mountyadisk.sh
```