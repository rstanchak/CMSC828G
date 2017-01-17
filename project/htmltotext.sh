#!/bin/sh
D=`pwd`
if [[ $# > 0 ]]; then
	D=$1
fi
echo Converting all HTML files found in $D
IFS='
'
for f in `find $D`; do
	if [ x`file -b "$f" | grep HTML` != x ]; then
		DIR=`dirname $f`
		BASENAME=`basename "$f" .html`
		TXT=$DIR/$BASENAME.txt
		if [ ! -f $TXT ]; then
			echo Converting $f to text $TXT
			html2text "file://$f" > "$TXT"
		fi
	else
		echo "$f is not HTML:"
		file "$f"
	fi
done
