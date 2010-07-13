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

#---------------------------------------------------------------
# Build script
#---------------------------------------------------------------
# Clean previously cimpiled files
echo " - Cleanup old files - "
rm -rf "../build/Release/"$ProjectName".app"
rm -rf "../build/Release/"$ProjectName".app.dSYM"

# Build project as Release
echo " - Compiling the project - "
xcodebuild -project "../"$ProjectName".xcodeproj" -configuration Release clean build

# Save build and debug symbols
mkdir ../out
mkdir ../out/saved
mkdir ../out/saved/$ProjectVersion
zip -r ../out/saved/$ProjectVersion/build$(date +%Y%m%d%H%M%S).zip "../build/Release/"$ProjectName".app" "../build/Release/"$ProjectName".app.dSYM"