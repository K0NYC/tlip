#!/usr/bin/env bash 

list=$(ls /Users/rlevit/Pictures/20* | cut -d '/' -f 5)

for file in $list
do
	echo "<a href=\"https://dzj2k1hwyehv0.cloudfront.net/thelifeinpictures/$file\"><img src=\"https://dzj2k1hwyehv0.cloudfront.net/thelifeinpictures/$file-small-150x101.png\" class=\"alignleft\" /></a>" >> url.txt

done

cat url.txt
