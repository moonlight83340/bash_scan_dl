#!/bin/bash
#Author Gaëtan

# @param directory
# @access private
init(){
	local directory="$1"
	if [ ! -d "${directory}" ]; then
        mkdir -p "${directory}"
	fi
}

# returns if chapter already own
# @param string directory chapter
# @return bool
# @access private
chapter_exist(){
	local directory="$1"
	if [ ! -d "${directory}" ]; then
        return 0
    else
		return 1
	fi
}
