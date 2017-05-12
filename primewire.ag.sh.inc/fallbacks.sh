#!/bin/bash

if [ -z "$search" ]; then
    search="0"
fi

if [ -z "$download" ]; then
    download="0"
fi

if [ -z "$player" ]; then
    player="kodi"
fi

if [ ! -z "$series" ]; then
    while [ ! -z "$1" ]; do
	shift
    done
    #echo -e "QS: $0 $series $search $season $episode $download $player"
    #exit 0
fi

if [ ! -z "$2" ] && [ -z "$search" ]; then
    search="$2"
fi

if [ ! -z "$1" ] && [ -z "$series" ]; then
    series="$1"
fi

if [ ! -z "$3" ] && [ -z "$season" ]; then
    season="$3"
fi

if [ ! -z "$4" ] && [ -z "$episode" ]; then
    episode="$4"
fi

if [ ! -z "$5" ] && [ -z "$download" ]; then
    download='y'
fi

if [ ! -z "$6" ] && [ -z "$player" ]; then
    player="$6"
fi
