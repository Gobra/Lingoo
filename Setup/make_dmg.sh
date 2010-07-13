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
rm -f $BuildPath
mkdir "../out/tmp"
mkdir $BuildBase
cp -R "../build/Release/"$ProjectName".app" "../out/tmp"
# cp -R "../License.rtf" "../out/tmp"

echo " - Making DMG - "
hdiutil create -anyowners -ov -srcfolder "../out/tm"p  -volname $ProjectName -uid 99 -gid 99 $BuildPath
hdiutil internet-enable -yes $BuildPath
#./create-dmg --window-size 500 300 --background ../Images/Background.jpg --icon-size 96 --volname "$ProjectName" --icon "Applications" 380 205 --icon "$ProjectName" 110 205 test2.dmg ../out/temp/

rm -rf "../out/tmp"