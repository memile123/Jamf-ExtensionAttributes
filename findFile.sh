#!/bin/sh
findFile="<File Name>"
myFile=`mdfind $findFile`
if [[ -n $myFile ]]; then
    echo "<result>FOUND</result>"
    exit 99
fi
exit 0
