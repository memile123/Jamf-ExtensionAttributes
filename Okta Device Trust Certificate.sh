#!/bin/bash

CERTNAME="Okta MTLS"
currentUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "
");')
query=$(security find-certificate -a /Users/$currentUser/Library/Keychains/okta.keychain | awk -F'"' '/alis/{print $4}')

if [ "$query" == "$CERTNAME" ]; then
  result="Yes"
else
  result="No"
fi

echo "<result>$result</result>"
