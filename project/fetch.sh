#!/bin/sh
# fetch all the urls in the file $1
# -nc no clobber -- don't redownload files we already have
# -x  alway save to directory

wget --directory-prefix=/tmp/working-roman/labelme/wikipedia_cache -i LM_wikipedia_urls.txt -nc -x
