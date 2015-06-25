#!/usr/bin/python
import pexpect
import getpass
import sys
command = sys.argv[1]
password = getpass.getpass()
IP_list = open('ip_addresses.txt')
IP = IP_list.readline()
while IP:
    print IP,
    cli="ssh pavlo@%s %s" % (IP,command)
    exp = pexpect.spawn(cli)
    exp.expect('password:')
    exp.sendline(password)
    exp.expect(pexpect.EOF)
    print exp.before
    IP = IP_list.readline()
IP_list.close()