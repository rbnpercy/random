#!/usr/bin/env python

import sys
import md5

for fn in sys.argv[1:]:
	print "Doing", fn

	f=open(fn)
	b=f.read()
	f.close()

	m=md5.md5(b)

	fout=open(fn + ".md5", "w")
	fout.write(m.hexdigest() + "\n")
	fout.close()
