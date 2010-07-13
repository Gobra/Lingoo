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

# Index documentation
echo " - Indexing help - "
if [ -a "/usr/bin/hiutil" ]; then
  # Using hiutil on Snow Leopard
  /usr/bin/hiutil --create "../Source/Resources/English.lproj/Help/" -a --file "../Source/Resources/English.lproj/Help/Help.helpindex"
else
  # Using Help Indexer.app
  /Developer/Applications/Utilities/Help\ Indexer.app/Contents/MacOS/Help\ Indexer ../Source/Resources/English.lproj/Help/
fi

# Build project as Release
echo " - Compiling the project - "
xcodebuild -project "../"$ProjectName".xcodeproj" -configuration Release clean build

# Save build and debug symbols
mkdir ../out
mkdir ../out/saved
mkdir ../out/saved/$ProjectVersion
zip -r ../out/saved/$ProjectVersion/build$(date +%Y%m%d%H%M%S).zip "../build/Release/"$ProjectName".app" "../build/Release/"$ProjectName".app.dSYM"