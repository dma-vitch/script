add_user.sh
----------


General syntax is as follows:

`useradd -m -p encryptedPassword username`

Where,

    -m : The user’s home directory will be created if it does not exist.
    useradd -p encryptedPassword : The encrypted password, as returned by crypt().
    username : Add this user to system

You need to create encrypted password using perl crypt():

`perl -e 'print crypt("password", "salt"),"\n"'`

Output:

sa3tHJ3/KuYvI 

Above will display the crypted password (sa3tHJ3/KuYvI) on screen. The Perl crypt() function is a one way encryption method meaning, once a password has been encrypted, it cannot be decrypted.
The password string is taken from the user and encrypted with the salt and displayed back on screen.

You can store an encrypted password using following syntax:
```
$ password="1Yeog@"
$ pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
$ echo $pass
```

Output

`
paU5t8Al/qf6M
`

Usage:
---------
Only root may add a user to the system

Run from root user

./adduser.sh

Enter username : myuser
Enter password : mypassword
User has been added to system!

Now user myuser can login with a password called mypassword.