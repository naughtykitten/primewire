#!/bin/bash

# sed 's_.*"/\(serie/.*\)" tit.*<strong>\(.*\)</strong></a>_\1 \2_')
#titles=$(tac "$file" | grep itemprop=\"name\" | sed -e 's_.*name\">\(Epis.*\)</span>.*_\1_g' | grep -v "<" | grep -v "'" | sed -e 's/\&nbsp\;\&nbsp\;\&nbsp\;/ /g' | sed -e "s/\&\#039\;/\'/g")
titles=$(cat "$file" | grep tv_episode_item | sed -e 's_.*>E\([^\"]*\)<.*>\([^\"]*\)</span>.*_E\1\2_g' )
links=$(cat "$file" | grep tv_episode_item | sed -e 's_.*href="\([^\"]*\)".*_\1_g' )
#| grep "s$season" | grep -v Random | )

if [ -z "$episode" ]; then
    echo "$titles"
    read -p "Enter choice: " episode
fi

#episode=$((episode + 1))
if [ "$episode" == 0 ]; then
    title=$(echo "$titles" | head -1)
    link=$(echo "$links" | head -1)
else
    title=$(echo "$titles" | sed -e "${episode}q;d")
    link=$(echo "$links" | sed -e "${episode}q;d" | head -1)
fi

#clean=$(echo "$link" | sed -e 's_/episode/\(.*\)\.html_\1_g')
clean=${link##/*/}
#make sure the episode directory exists
file=$(echo "$clean.html") # | sed -e 's/\/episode\/\(.*\)\.html/\1/g' ) #| sed -e 's/\(.*\)\/.*$/\1\//g')

if [ ! -d "$file" ]; then
    mkdir -p "$cache/$file"
fi

file="$cache/$file.html"
rm -f "$file"
if [ ! -f "$file" ] || [ ! -s "$file" ]; then
    #wget -o "$output" -O - $site/$link > $file
    curl -L --silent "$site/$link" > "$file"
fi
