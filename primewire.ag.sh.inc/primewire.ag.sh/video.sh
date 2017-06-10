#!/bin/bash

links=$(tac "$file" | grep goto\.php | grep href | grep -v script | grep Watch | sed 's_.*&url=\(.*\)&domain.*_\1_g' )
domain=$(tac "$file" | grep goto\.php | grep href | grep -v script | grep Watch | sed 's_.*&domain=\(.*\)&loggedin.*_\1_g' | tr "\n" " " )
domain=($domain)
#firefox-esr "file://$file"
#| grep "cale" | sed 's_.*?r=\(.*\)" cl.*title="\(.*\)" style.*_\1_g');
#links=$(echo "$links" )
#openssl base64 -d

if [ ! -f "$file" ] || [ ! -s "$file" ]; then
    echo "There are no links. Removing file and exiting.";
    rm -f "$file"
    exit 0
fi

# ofs=$IFS
# count=1
# IFS=$'\n'
# for link in $links; do
#     l[$count]=$(echo "$link" | openssl base64 -d)

#     youtube-dl -i -g "${l[$count]}"
    
#     count=$(($count+1))
# done
# IFS=$ofs

# exit 0

ofs=$IFS
count=1
IFS=$'\n'
for link in $links; do
    l[$count]=$(echo "$link" | openssl base64 -d)
    dom[$count]=$(echo ${domain[$count]} | openssl base64 -d)
    #echo "${l[$count]}"
    #echo "$0.inc/blacklist/${dom[$count]}"

    if [ -f "$0.inc/blacklist/${dom[$count]}" ] || [ -z "${dom[$count]}" ]; then
	count=$(($count+1))
	continue
    fi
    
    file="$cache/$episode_$title.html"
    url=''
    #if [ ! -f "$file" ]; then
	#curl --silent $site/${l[$count]} > $file
	rm -f $file;
	#echo "${l[$count]}"
	
	code=$(curl -L -s -o /dev/null -w "%{http_code}" "${l[$count]}");

	if [ "$code" = "200" ]; then
	    error=$(youtube-dl -g "${l[$count]}" 2>&1 )
	    if [ -z "${error##*Unsupported URL*}" ]; then
		echo "Blacklisting unsupported domain: ${dom[$count]}"
		#echo "$error"
		echo "" > "$0.inc/blacklist/${dom[$count]}"
		count=$(($count+1))
	        continue
	    fi
	    
	    url=$(youtube-dl -g "${l[$count]}")
	    filename=$(youtube-dl --get-filename "${l[$count]}")
	fi

	#echo "$url" > "$file"
	#echo "$url" > $file

	# if [ -s "$file" ]; then
	#     rm -f $file
	# fi
    #fi
       
    ext=$(echo "$url" | sed -e 's_.*\.\(.*\)$_\1_g')
#if false; then
    clean=$(echo "$link") # | sed -e 's/[^a-zA-Z0-9]*/_/g')
    
if [ ! -z "$url" ]; then    
    #video="$cache/$clean.$ext"
    #if [ ! -z "$ext" ] || [ -f "$file" ]; then

	# if [ ! -f "$video" ] || [ -s "$video" ]; then
	#     #url=$(cat "$file")
	    
	#     if [ -z "$download" ]; then
	# 	read -p "Cache episode locally before playing? Y/N " download
	#     fi

	#     if [ "$download" = 'y' ]; then 
	# 	#wget -o "$output" -O - "$url" > "$video" &
	# 	#curl --silent 
	# 	#curl -o "$video" "$url" > "$video" &
	# 	#> "$cache/episode/$clean.curl.log" &
	# 	wget_log="$cache/$clean.wget.log"

	# 	if [ ! -f "$wget_log" ]; then
	# 	   wget -o "$wget_log" -O - "$url" > "$video" &
	# 	fi
		
	# 	# while true; do
	# 	#     echo -en '\033[s'
	# 	#     wget_str=$(tail -2 "$wget_log" | grep % | tail -1 | sed -e 's_ \([0-9]*\)K.* \([0-9]*\)\%_\1K \2%_g')
		    
	# 	#     echo "$wget_str : ${wget_data[3]}"
		    
	# 	#     echo  -n 
	# 	#     echo -en '\033[u'
		    
	# 	#     sleep 2
	# 	# done
	# 	#tail -f "$cache/episode/$clean.wget.log" &

	# 	#exit 0
	#     fi

	#     sleep 10
	# fi

	#video=$(cat $video)
	#echo "$video";
	
	# if [ -s "$video" ]; then
	#     rm -f "$video"
	# fi

#	if [ ! -f "$video" ]; then

    video=$(echo "$cache/$title.mp4" | sed -e 's_ \(\.\)_._g')
    wget_log="/home/kodi/$site.sh.log"
    
    # if [ ! -f "$video" ]; then
    # 	if [ -f "/usr/bin/axel" ]; then
    # 	    axel -n 4 -o "$video" "$url" > "$wget_log" &
    # 	else
    # 	    
    # 	fi
    # fi
	#echo "$video";

	    if [ -z "$player" ]; then
		echo "Open $title with:\n1) Kodi\n2) mpv\n3) VLC \n"
		read -p "Enter choice: " player
	    fi

	    if [ -f "$video" ]; then
		echo "=====================START DOWNLOAD MINITOR====================";
		#incomplete
		#wget -o "$wget_log" -O - "$url" > "$video" &
	    fi

	    logPath=$(echo "$0.inc/history/"${series%&*}"_S$season""_E$episode.url")
	    echo "$url" > "$logPath"

	    echo "Steaming from: ${dom[$count]}"
	    
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

	    # if [ -z "$player" ]; then
	    # 	while true; do
	    # 	    read line;
	    # 	    echo "$line" > "$input"
	    # 	done
	    # fi

	#fi
    #fi
fi
    
count=$(($count+1))
done
IFS=$ofs
