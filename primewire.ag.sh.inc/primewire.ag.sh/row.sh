#!/bin/bash

series="$series&search_section=2"

links=$(cat "$page" | grep href)

test=$(echo "$links" | sed 's/[^a-zA-Z0-9]//g')

while [ -z "$test" ]; do
    links=$(cat "$page" | grep href)
    test=$(echo "$links" | sed 's/[^a-zA-Z0-9]//g')
    
    #echo "$links" | trim; exit 0;
    if [ -z "$links" ]; then
	curl "$curl_headers" --silent "$proto$site/$qs$series" > "$page"
    fi

    #fuck cloudflare
    #check for cloudflare

    cf_check=$(cat "$page" | grep "400\sBad")
    
    while [ ! -z "$cf_check" ]; do
	echo "query: $proto$site/$qs$series"
	echo -e "cf ? $cf_check"
	rm -f "$page"
	curl "$curl_headers" --silent "$proto$site/$qs$series" > "$page"
	
	cf_check=$(cat "$page" | grep "400\sBad\srequest")
	sleep 4
    done
done

#echo "$links" | grep 'title="Watch' | grep index_item;

links=$(echo "$links" |\
 grep 'title="Watch' |\
 grep index_item |\
 sed 's_.*a href="\(.*\)" title="Watch \([^"]*\)">.*thumbs/\(.*\)\.jpg".*_\1 \3 \2_' )

ofs=$IFS
count=0
IFS=$'\n'
for link in $links; do
    l[$count]=$(echo $link | cut -d\  -f1)
    p[$count]=$(echo $link | cut -d\  -f2)
    t[$count]=$(echo $link | cut -d\  -f3-)
    
    if [ -z "$search" ]; then
	echo "$count) ${t[$count]}"
    fi
    count=$(($count+1))
done
IFS=$ofs

if [ -z "$search" ]; then
    read -p "Enter choice: " search
fi

series_t="${t[$search]}"

clean=$(echo "${t[$search]}") # | sed -e 's/serie[^a-zA-Z0-9 _]*//g')
file="$cache/$clean.html"
#rm -f "$file"
#if [ ! -f "$file" ] || [ ! -s "$file" ]; then
    curl -L --silent "$site/${l[$search]}" > "$file"
    #wget -o "$output" -O - $site/${l[$input]} > $file
#fi


