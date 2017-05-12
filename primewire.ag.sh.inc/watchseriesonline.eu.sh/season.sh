#!/bin/bash

links=$(tac "$file" |\
 grep itemprop=\"name\" |\
 grep season |\
#grep -v "$season$season" |\
 sed -e 's_.*href="\([^\"]*\)".*name">\(.*\)</span>.*_\1 \2_g')

ofs=$IFS
count=1
IFS=$'\n'
for link in $links; do
    l[$count]=$(echo $link | cut -d\  -f1)
    t[$count]=$(echo $link | cut -d\  -f2-)
    
    if [ -z "$season" ]; then
	echo $count\) ${t[$count]} #${l[$count]}
    fi
    count=$(($count+1))
done
IFS=$ofs

if [ -z "$season" ]; then
    read -p "Enter choice: " season
fi

season_t="${t[$season]}"
cache="$cache/${t[$season]}"

if [ ! -d "$cache" ]; then
    mkdir "$cache"
fi

lower=$(echo "${t[$season]}" | grep -v "$season$season" )
file="$cache/$clean\_$lower.html"
if [ ! -f "$file" ] || [ ! -s "$file" ]; then
    #wget -o "$output" -O - $site/${l[$season]} > $file
    curl --silent "$site/${l[$season]}" > "$file"
fi
