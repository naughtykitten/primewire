#!/bin/bash

verbose=0

while getopts "hd:pt:m:v:k:r:s:e:ln" opt; do
    case "$opt" in
	l)
	    loadPath=1
	    #cat $0.inc/
	    ;;
	n)
	    #next
	    exit 0
	    ;;
	t)
	    series="$OPTARG"
	    type="show"
	    ;;
	e) 
	    episode="$OPTARG"
	    ;;
	s)
	    season="$OPTARG"
	    ;;
	
	k)
	    if [ "$OPTARG" = "pv" ]; then
		player="kodi"
	    fi
	    ;;
	m)
	    #name | series="$1"
	    if [ "$OPTARG" = "pv" ]; then
		player="mpv"
	    else #movie
		type="movie"
		series="$OPTARG"
	    fi
	    ;;
	r)
	    search="$OPTARG"
	    ;;
	d)
	    download=1
	    ;;
	v)
	    if [ "$OPTARG" = "lc" ]; then
		player="vlc"
	    else
		verbose=1
	    fi
	    ;;
	c)
	    player="chromecast"
	    ;;
	h)
	    echo "==== Arguments ====";
	    echo -e "Title:\t\t-t | -m\tDoctor\ Who or \"Doctor Who\""
	    echo -e "Result row:\t-r\t1 (default is 0) (1 in this case is 2005 Doctor Who vs classic )"
	    echo -e "Season:\t\t-s\t9"
	    echo -e "Episode:\t-e\t4"
	    echo -e "Media Player:\t-kodi | -mpv | -vlc"
	    echo -e "\nExample: $0 -t Doctor\ Who -r 1 -s 9 -e 4 -mpv"

	    exit 0;
	    ;;
	\?)
	    echo "Flag $opt = $OPTARG";
	    exit
	    ;;
    esac
done

logPath=$(echo "$0.inc/history/"${series%&*}"_S$season""_E$episode.url" | sed 's/ /+/g')
if [ -f "$logPath" ]; then
    url=$(cat $logPath)
    
    case "$player" in
	1|Kodi|kodi)
	    curl --silent -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"GUI.ShowNotification","params":{"title":"Playing '"$series_t"'","message":"'"$title"'"},"id":1}' http://kodi@localhost:8080/jsonrpc > /dev/null
	    ./kodi "$url" 
	    read -p "Press ^C when complete or ESC if video fails to load." complete
	    ;;
	2|mpv)
	    #tail -f "$input" | mpv "$video" >> "$output" &
	    if [ -f "/usr/local/bin/mypv" ]; then
		mypv "$url"
	    else
		#/usr/local/bin/mypv
	    	mpv --cache 128000 --cache-seek-min 100 --cache-initial 200 --fullscreen "$url"
	    fi
	    ;;
	3|VLC|vlc)
	    vlc "$url"
	    ;;
	4|chromecast)
	    stream2chromecast -playurl "$url"
	    ;;
    esac
fi
