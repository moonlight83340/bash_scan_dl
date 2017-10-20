#!/bin/bash
#Author Gaëtan

usage(){
	echo -e "Usage: $0 <fichier> [target-dir] : search mangas in file to download\n\
	$0 --update : For update\n\
	$0 -h : For help\n\
	$0 --help : For help\n\
	$0 -usage : For help";
	exit 1;
}

URLUPDATER="http://"

if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "-usage" ]; then
	usage
elif [ "$1" = "--update" ] && [ "$1" = "-u" ]; then
	selfUpdate "$URLUPDATER" "${0##*/}"
fi

file="$1"
cat $file | while  read ligne ; do
	echo "$ligne"
  ./getScan.sh "$ligne" "$2"
done
exit 0
