#!/bin/bash

#---------------------------------------------------------------
# Helpers
#---------------------------------------------------------------
function ReadFileLines()
{
	number=0
	while read line
	do
		if (($number >= $2)) && (($number <= $3)); then
			echo $line
		fi
		number=$((number+1))
	done < $1
	
	if (($number >= $2)) && (($number <= $3)); then
		echo $line
	fi
}

#---------------------------------------------------------------
# Pre-defines
#---------------------------------------------------------------
ProjectName=$(ReadFileLines "build_params.txt" 0 0)
ProjectVersion=$(ReadFileLines "build_params.txt" 1 1)
BuildBase="../out/saved/"$ProjectVersion
BuildPath=$BuildBase"/"$ProjectName".dmg"

# Push future DMG contents to the temporary directory and make DMG
dmgcanvas ProjectName"Dmg.dmgCanvas" BuildPath