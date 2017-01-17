#!/usr/bin/python

import sys
import getopt

sys.path.append('/fs/junkfood/roman/localroot/generic/usr/share/pYsearch-3.1/build/lib')

from yahoo.search.web import WebSearch

f = open(sys.argv[1], 'r')

for q in f.xreadlines():
    q = q.rstrip()
    if len(q)==0:
        print " "
        continue
    srch = WebSearch('YahooDemo', query=q, site='wikipedia.org')
    info = srch.parse_results()

    if len(info.results)==0:
        print " "
        continue

    for result in info.results:
        print "%s" % (result['Url'])
        break
