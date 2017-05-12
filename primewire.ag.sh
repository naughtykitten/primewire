#!/bin/bash

PWD=$(pwd)

#contains getopts
source "$0.inc/options.sh"

#fallback to default if no config has been loaded
if [ -z "$fn_row"]; then
    source "$0.inc/primewire.sh"; 
fi

cache="$PWD/.cache/$site"

input="$cache/input.log"
output="$cache/output.log"

curl_headers="-H 'Host: primewire.ag' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:41.0) Gecko/20100101 Firefox/41.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'DNT: 1' -H 'Cookie: __utma=92638556.121278295.1448850146.1477958681.1480919006.14; __utmz=92638556.1448850146.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.2.121278295.1448850146; __cfduid=d4d06fd1b44807367daef7817ecf2b3f61480918998; __utmb=92638556.1.10.1480919006; __utmc=92638556; __utmt=1; _gat_Insticator_Header_Code=1; _gat_Insticator_Header_Bidding_V7=1' -H 'Connection: keep-alive'"

log="$cache/$site.log"

if [ ! -d $cache ]; then
    mkdir -p $cache
fi

#sets needed variables
#source "$0.inc/fallbacks.sh"

# ======== Series ======== >>>
if [ -z "$series" ]; then
    read -p "What would you like to watch? " series
fi

if [ -z "$qs" ]; then
    qs="search/$series"
fi

if [ ! -d "$cache/$series" ]; then
    mkdir -p "$cache/$series"
    # else
    #    ls $cache
fi

cache="$cache/$series"

page="$cache/search.html"

if [ ! -z "$fn_qs" ]; then
    source "$fn_qs"
fi

if [ ! -f "$page" ] || [ ! -s "$page" ]; then

    #curl --silent $site/search/Simpsons |\
    if [ ! -f "$page" ]; then
	
	#wget -o "$output" -O - $proto$site/search/$series > "$cache/$page"
	curl "$curl_headers" --silent "$proto$site/$qs" > "$page"
	#cache="~/.cache/$site/$series/"
    fi
    
fi

# ======== Series ======== <<<

# ======== Result row ======== >>>

if [ ! -z "$fn_row" ]; then
    source "$fn_row"
else
    echo 'Result row handler failed.'
    exit 0
fi

# ======== Result row ======== <<<

# ======== Season ======== >>>
#<a href="/the_simpsons/season-18" itemprop="url"><span itemprop="name">Season 18</span></a>

if [ ! -z "$fn_season" ]; then
    source "$fn_season"
fi

# ======== Season ======== <<<

# ======== Episode ======== >>>

if [ ! -z "$fn_episode" ]; then 
    source "$fn_episode"
fi

# ======== Episode ======== <<<

# ======== Links ======== >>>

if [ ! -z "$fn_video" ]; then 
    source "$fn_video"
else
    echo 'Links handler failed.'
    exit 0
fi

# ======== Links ======== <<<
