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

# Push future DMG contents to the temporary directory and make DMG
abspath="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"
script_path=`dirname "$abspath"`
project_path="$(dirname "$script_path")"
TemplatePath=$script_path"/Dmg/"$ProjectName"Dmg.dmgCanvas"
BuildPath=$project_path"/out/saved/"$ProjectVersion"/"$ProjectName$ProjectVersion".dmg"

dmgcanvas $TemplatePath $BuildPath -leopard-compatible yes