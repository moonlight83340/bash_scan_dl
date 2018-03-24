#!/bin/bash
#Author Gaëtan

JPSCAN="jpscan"
MANGAREADER="manga-reader"
MANGASUPA="mangaSupa"
webSiteUse=JPSCAN

usage(){
	echo "Usage: $0 <name-of-manga> [target-dir]";
	exit 1;
}

# gets the manga
# @param string name of manga
# @return number of chapter
# @access public
nbChapter(){
	#first use jpscanlib
	. jpscanlib.sh
	URL="http://www.japscan.com/lecture-en-ligne/${1}/"
	getChapterCount "$URL" "$1"
	local chapter="$?"
	if [ $chapter -eq 0 ];then
		#if jpscan have no result we try on manga-reader
		. manga-readerlib.sh
		URL="http://www.mangareader.net/${1}"
		getChapterCount $URL $1
		chapter="$?"
		webSiteUse=$MANGAREADER
	fi
	if [ $chapter -eq 0 ];then
		#if mangareader have no result we try on mangaSupa
		. mangasupalib.sh
		getChapterCount "$BASE_URL" "$1"
		chapter="$?"
		webSiteUse=$MANGASUPA
	fi	
	return "$chapter"
}

# gets the manga
# @param string name of manga
# @param string chapter of manga
# @param string target directory in which manga will be stored
# @return number exit status
# @access public
getScanBychapter(){
	nbChapter "$1"
	local chapter=$?
	if [ $chapter -gt 0 ];then
		echo "Manga : $1"
		echo "Nombre de chapitre disponible : $chapter"
		echo "Utilisation de $webSiteUse..."
		get "$1" "$2" "$3"
		if [ $? -eq 0 ]; then
			echo "Téléchargement terminé, un chapitre téléchargé"
		fi
	else
		echo "Aucun scan trouvé... Mauvais nom ou bien scan non disponible"
	fi
}

# gets the manga
# @param string name of manga
# @param string target directory in which manga will be stored
# @access public
getAllScan(){
	nbChapter "$1"
	local chapter=$?
	if [ $chapter -gt 0 ];then
		echo "Manga : $1"
		echo "Nombre de chapitre disponible : $chapter"
		echo "Utilisation de $webSiteUse..."
		local nbChapterDl=0
		for (( chap=1; chap<=$chapter; chap++ )); do
			get "$1" $chap "$2"
			if [ $? -eq 0 ]; then
				(( nbChapterDl++ ))
			fi
		done;
		echo "Téléchargement terminé, $chapter chapitres téléchargé"
	else
		echo "Aucun scan trouvé... Mauvais nom ou bien scan non disponible"
	fi
}
