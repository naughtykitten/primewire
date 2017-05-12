#!/bin/bash

links=$(cat "$page" |\
 grep '/serie/' |\
 grep href |\
 sed 's_.*"/\(serie/.*\)" tit.*<strong>\(.*\)</strong></a>_\1 \2_')

ofs=$IFS
count=0
IFS=$'\n'
for link in $links; do
    l[$count]=$(echo $link | cut -d\  -f1)
    t[$count]=$(echo $link | cut -d\  -f2-)
    
    #if [ -z "$search"]; then
	echo "$count) ${t[$count]} ${l[$count]}"
    #fi
    count=$(($count+1))
done
IFS=$ofs

if [ -z "$search" ]; then
    read -p "Enter choice: " search
fi

series_t="${t[$search]}"

clean=$(echo "${t[$search]}") # | sed -e 's/serie[^a-zA-Z0-9 _]*//g')

file="$cache/$clean.html"
if [ ! -f "$file" ] || [ ! -s "$file" ]; then
    curl --silent "$site/${l[$search]}" > "$file"
    #wget -o "$output" -O - $site/${l[$input]} > $file
fi

