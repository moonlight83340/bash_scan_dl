#!/bin/bash
#Author Gaëtan

#main

usage(){
	echo "Usage: $0 <name-of-manga> [target-dir]";
	exit 1;
}

#first use jpscanlib
. jpscanlib.sh
URL="http://www.japscan.com/lecture-en-ligne/${1}/"
getChapterCount "$URL" "$1"
chapter=$?
echo $chapter
if [ $chapter -eq 0 ];then
	#if jpscan have no result we try on manga-reader
	. manga-readerlib.sh
	URL="http://www.mangareader.net/${1}"
	getChapterCount $URL $1
	chapter=$?
	echo $chapter
fi
for (( chap=1; chap<=$chapter; chap++ )); do
	get "$1" $chap "$2"
done;
exit 0

