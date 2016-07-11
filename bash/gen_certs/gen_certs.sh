!/bin/bash
echo -e "\nPlease enter a name for your SSL Certificate and Key pairs:"
read name
openssl req -x509 -newkey rsa:1024 \
        -keyout /etc/pki/tls/certs/$name.key.pem -out /etc/pki/tls/certs/$name.cert.pem \
        -nodes -days 365
chmod 0600 /etc/pki/tls/certs/$name.key.pem

