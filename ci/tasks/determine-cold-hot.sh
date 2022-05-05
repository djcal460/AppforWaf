#!/bin/sh

set -e

ls -ltr

cat gtm-source/targets.json | jq -r '[.targets[] | { "key": .handoutCName | split("-")[2], "value": .weight }] | from_entries' >> blue-green-stat.json

bluewebtier=`cat blue-green-stat.json | jq -r '.blue'`

echo "bluewebtier: $bluewebtier"

if [ "$bluewebtier" -eq 1 ];  then
   echo "blue akamai active"
   cp blue-green-stat.json blue-green-stat/blue-stat.json
else
   echo "green akamai active"
   cp blue-green-stat.json blue-green-stat/green-stat.json
fi

ls -ltr
cat blue-green-stat/*-stat.json

ls -ltr blue-green-stat