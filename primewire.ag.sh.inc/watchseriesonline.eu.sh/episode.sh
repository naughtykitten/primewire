#!/bin/bash

# sed 's_.*"/\(serie/.*\)" tit.*<strong>\(.*\)</strong></a>_\1 \2_')
titles=$(tac "$file" | grep itemprop=\"name\" | sed -e 's_.*name\">\(Epis.*\)</span>.*_\1_g' | grep -v "<" | grep -v "'" | sed -e 's/\&nbsp\;\&nbsp\;\&nbsp\;/ /g' | sed -e "s/\&\#039\;/\'/g")
links=$(cat "$file" | grep href | grep episode | grep "s$season" | grep -v Random | sed -e 's_.*href="\(/episode/[^\"]*\)".*_\1_g' | grep -v "<")

if [ -z "$episode" ]; then
    echo "$titles"
    read -p "Enter choice: " episode
fi

title=$(echo "$titles" | sed -e "${episode}q;d")
link=$(echo "$links" | grep "e$episode" | grep "e$episode\."| head -1)
clean=$(echo "$link" | sed -e 's_/episode/\(.*\)\.html_\1_g')


#make sure the episode directory exists
file=$(echo "$link" | sed -e 's/\/episode\/\(.*\)\.html/\1/g' ) #| sed -e 's/\(.*\)\/.*$/\1\//g')

if [ ! -d "$file" ]; then
    mkdir -p "$cache/$file"
fi

file="$cache/$file.html"
if [ ! -f "$file" ] || [ ! -s "$file" ]; then
    #wget -o "$output" -O - $site/$link > $file
    curl --silent "$site/$link" > "$file"
fi
