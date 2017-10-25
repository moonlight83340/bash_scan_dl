#!/bin/bash
#Author Gaëtan

. utils.sh

BASE_URL="http://mangasupa.com/"
#if the url contain the vol no we have to know
VOL=0

# gets the manga
#
# @param string name of manga
# @param string chapter of manga
# @param string target directory in which manga will be stored
# @return number exit status
# @access public
get () {
    local name="$1"
    local chapter=$2
    local directory="${3:-$PWD}"
    
    # URL to main page of chapter
    local URL="${BASE_URL}chapter/${name}/chapter_${chapter}"

    # directory of chapter
    directory="${directory}/${name}/${chapter}"
	chapter_exist "$directory"
	if [ $? -eq 1 ];then
		init "$directory"
		echo "Get chapter ${chapter}..."
		getPages "$URL" "$name" $chapter "$directory"
	else
		echo "You already have chapter ${chapter}"
	fi
    return $?
}

# returns count of chapter
# @param string URL of manga page
# @param string manga name
# @return count
# @access private
getChapterCount () {
	local URL=$1
	local name=$2
    local ChapterCount=$(wget -q "${URL}manga/${name}" -O - | grep -o 'href="'${URL}chapter/${name}/chapter_[0-9]*'' | head -1 | grep -oP "[0-9]*")
    return $ChapterCount;
}

# downloads all pages
# @param url name chapter directory
# @access private
getPages () {
	local URL="$1"
	local name="$2"
	local chapter=$3
	local directory="$4"
    getPageCount "$URL"
    local pages=$?
    echo "Found ${pages} pages."
	#download all page of the chapter
	wget "$URL"
	wget $(cat "chapter_$chapter" | grep '[0-9].jpg' | grep -oP "(?<=src=\").*?(?=\")") --directory-prefix=${directory} -nc
	rm "chapter_$chapter"
    return 0
}

# get the name of all mangas into a file
# @param file
# @access private
getAllMangasInFile(){
	file="$1"
	SEPARATOR=' '
	SEPARATORREPLACE="\n"
	nbPage=$(wget -q "http://mangasupa.com/manga_list?type=topview&category=all&state=all&page=1" -O - | grep -oP "(?<=LAST\().*?(?=\))")
	echo $nbPage
	for (( page=1; page<=$nbPage; page++ )); do
		echo "Analyse page $page"
		wget -q -O tmp "http://mangasupa.com/manga_list?type=topview&category=all&state=all&page=$page"
		str=$(sed -n '/<div class="cotgiua">/,/<div class="cotphai">/ p' tmp | grep -oP "(?<=href=\"http://mangasupa.com/chapter/).*?(?=/chapter_)")
		str="${str// /$'\n'}"
		echo "$str" >> $file
		rm tmp
	done;
	cat $file
}
