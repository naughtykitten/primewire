#!/bin/bash

qs='index.php?search_keywords='

rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  #echo "${encoded}"    # You can either set a return variable (FASTER) 
  #REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
  series="$qs${encoded}&search_section=2"
}

#rawurlencode "$series"

series=$(echo $series | sed -e 's/ /+/g');

qs="$qs$series";
#echo "$proto$site/$qs$series";
