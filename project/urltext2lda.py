#!/usr/bin/env python
import sys,os
from urlparse import urlparse

STOP = {}
# read list of stop words
if len(sys.argv)>2:
    f = open(sys.argv[2])
    for l in f.xreadlines():
        STOP[ l.rstrip() ]=1
    f.close()
else:
    print "No list of stop words specified"

cache_dir='/tmp/working-roman/labelme/wikipedia_cache'
f = open(sys.argv[1])

DOCS = []
WORDS = []
DICT = {}

docidx=0
wordidx=1

import re
# pattern to strip non-word characters
strip_nw=re.compile('[^a-zA-XZ]+')

URLS=[]
for l in f.xreadlines():
    docidx+=1
    url = l.rstrip()
    urlparts = urlparse(url)
    urlcache = cache_dir + "/" + urlparts[1] + urlparts[2]  
    if len(urlparts[3])>0:
        urlcache += '?' + urlparts[3]

    # change extension to txt
    fileparts = urlcache.split('.')
    if len(fileparts[-1])<=4:
        urlcache = '.'.join(fileparts[0:-1])
    urlcache += ".txt"
        
    if not os.path.exists( urlcache ):
        continue

    uf = open( urlcache )
    for ul in uf.xreadlines():
        words = strip_nw.subn(' ', ul.rstrip().lower())[0].split()
        for w in words:
            # skip if length is <= 2
            if len(w)<=2:
                continue
            # skip if its a stopword
            if STOP.has_key(w):
                continue
            # add to dictionary
            if not DICT.has_key(w):
                DICT[w] = wordidx
                wordidx+=1
            WORDS.append(DICT[w])
            DOCS.append(docidx)
    uf.close()
    URLS.append(url)
f.close()

def dump_file(fname, strarr):
    f = open(fname, 'w')
    for s in strarr:
        f.write(s+"\n")
    f.close()

DICT_WORDS = DICT.keys()
DICT_WORDS.sort(  lambda a,b: cmp(DICT[a], DICT[b]) )
dump_file('words.txt', map(str,WORDS))
dump_file('docs.txt', map(str,DOCS))
dump_file('dict.txt', DICT_WORDS)
dump_file('doc_urls.txt', URLS)
