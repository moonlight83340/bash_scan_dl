#!/bin/bash
#Author Gaëtan
. getScan.sh
usage(){
	echo -e "Usage:  $0 <File> [target-dir] : search mangas in file to download\n\
	$0 --update : For update\n\
	$0 -h : For help\n\
	$0 --help : For help\n\
	$0 -usage : For help\n\
	$0 <name-of-manga> -c <numChapter> [target-dir] : For a chapter\n\
	$0 <name-of-manga> -nc\n\
	$0 <name-of-manga> -nbChapter\n\
	$0 <name-of-manga> -m [target-dir]\n\
	$0 <name-of-manga> --manga [target-dir]\n\
	$0 <File> --mangaSupaGetAll\n\
	$0 <File> -msGetAll";
	
	exit 1;
}

URLUPDATER="http://"

if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "-usage" ]; then
	usage
elif [ "$1" = "--update" ] || [ "$1" = "-u" ]; then
	selfUpdate "$URLUPDATER" "${0##*/}"	
elif [ "$2" = "--chapter" ] || [ "$2" = "-c" ]; then
	getScanBychapter "$1" "$3" "$4"
elif [ "$2" = "--nbChapter" ] || [ "$2" = "-nc" ]; then
	nbChapter "$1"
	nbChapter=$?
	echo "Il y a $nbChapter chapitres disponible"
elif [ "$2" = "--manga" ] || [ "$2" = "-m" ]; then
	getAllScan "$1" "$3"
elif [ "$2" = "--mangaSupaGetAll" ] || [ "$2" = "-msGetAll" ]; then
	. mangasupalib.sh
	getAllMangasInFile "$1"
else
	file="$1"
	cat $file | while  read ligne ; do
		echo "$ligne"
		getAllScan "$ligne" "$2"
	done
fi
exit 0
