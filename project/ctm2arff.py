#!/usr/bin/env python

import sys

f=open(sys.argv[1],'r')

for line in f.xreadlines():
    words=line.split()
    topics=
    for w in words[1:]:
        (word,topic)=w.split(':')

    # convert to normalized histogram

f.close()
