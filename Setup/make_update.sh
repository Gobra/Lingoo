#!/bin/bash

#---------------------------------------------------------------
# Helpers
#---------------------------------------------------------------
function ReadFile()
{
	while read line
	do
		accum="${accum}${line}"
	done < $1
	accum=${accum}${line}
	
	echo $accum
}

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
FtpServerName=$(ReadFileLines "build_params.txt" 2 2)
FtpUser=$(ReadFileLines "build_params.txt" 3 3)
FtpPassword=$(ReadFileLines "build_params.txt" 4 4)
FtpRoot=$(ReadFileLines "build_params.txt" 5 5)
HttpRoot=$(ReadFileLines "build_params.txt" 6 6)
RemoteUpdatesDirectory=$(ReadFileLines "build_params.txt" 7 7)
AppcastFileName=$(ReadFileLines "build_params.txt" 8 8)

#---------------------------------------------------------------
# Build script
#---------------------------------------------------------------
abspath="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"
script_path=`dirname "$abspath"`
project_path="$(dirname "$script_path")"
BuildPath=$project_path"/out/saved/"$ProjectVersion

# Pack new update & remember zip size
echo " - Packing update - "
UpdateBase=$ProjectVersion
UpdateName=$ProjectName$UpdateBase".zip"
UpdateFile=$BuildPath"/"$UpdateName

mkdir $BuildPath
cd "../build/Release"	# we can't ignore paths in zip (-j) because .app is folder, but we don't need build/Release/ part too
zip -r $UpdateFile $ProjectName".app"
cd "../../Setup"		# go back
UpdatePackageSize=$(stat -f %z $UpdateFile)

# Sign the update and get resulting SHA-1 signature
echo " - Signing update - "
UpdateSignature=$(ruby "Helpers/sign_update.rb" $UpdateFile ../Keys/sparkle_private.pem)

# Create temporary directory to:
# 1. download currect 'appcast' there
# 2. create new 'appcast'
echo " - Making appcast info - "

# 1.
curl -s $HttpRoot"/"$RemoteUpdatesDirectory"/"$AppcastFileName -o $BuildPath"/temporary.xml"

# 2.
appcastHeader=$(ReadFileLines $BuildPath"/temporary.xml" 0 6)				# read old header
appcastFooter=$(ReadFileLines $BuildPath"/temporary.xml" 7 99999)			# read old footer
releaseNotes=$(ReadFile "ReleaseNotes/"$ProjectVersion".html")

cat > $BuildPath"/"$AppcastFileName << EOF
$appcastHeader
<item>
    <title>Version $ProjectVersion</title>
    <pubDate>$(date)</pubDate>
    <enclosure url="$HttpRoot/$RemoteUpdatesDirectory/$UpdateName"
               sparkle:version="$ProjectVersion"
               sparkle:dsaSignature="$UpdateSignature"
               length="$UpdatePackageSize"
               type="application/octet-stream" />
	<description><![CDATA[$releaseNotes]]></description>

</item>
$appcastFooter
EOF

rm $BuildPath"/temporary.xml"