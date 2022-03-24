#!/bin/sh
# Identify App Store vs non App Store.

if [ -e /Applications/Slack.app ]; then
    if [ -e /Applications/Slack.app/Contents/_MASReceipt/ ]; then
        echo "<result>AppStoreCopy</result>"
    else
        echo "<result>NonAppStoreCopy</result>"
    fi
else
    echo "<result>NotInstalled</result>"
fi
