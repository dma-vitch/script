#!/usr/bin/python
import crypt;
import sys;
print crypt.crypt(sys.argv[1],”salt”);