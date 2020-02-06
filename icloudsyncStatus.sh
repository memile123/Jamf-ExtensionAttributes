#!/bin/bash

#Path to PlistBuddy
plistBud="/usr/libexec/PlistBuddy"

#Determine logged in user
loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

#Determine whether user is logged into iCloud
if [[ -e "/Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist" ]]; then
    iCloudStatus=$("$plistBud" -c "print :Accounts:0:LoggedIn" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )

    #Determine whether user has Drive enabled. Value should be either "false" or "true"
    if [[ "$iCloudStatus" = "true" ]]; then
        for i in {1..20}
        do
            #Iterate over ServiceIDs to find com.apple.Dataclass.KeychainSync
            ServiceID=$("$plistBud" -c "print :Accounts:0:Services:$i:ServiceID" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )
            if [[ "$ServiceID" = "com.apple.Dataclass.KeychainSync" ]]; then
                iCKStatus=$("$plistBud" -c "print :Accounts:0:Services:$i:Enabled" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )
                if [[ "$iCKStatus" = "true" ]]; then
                    iCKStatus="YES"
                    break
                else
                    iCKStatus="NO"
                    break
                fi
            fi

        done
    fi
    if [[ "$iCloudStatus" = "false" ]] || [[ -z "$iCloudStatus" ]]; then
        iCKStatus="NO"
    fi
else
    iCKStatus="NO"
fi

/bin/echo "<result>$iCKStatus</result>"
