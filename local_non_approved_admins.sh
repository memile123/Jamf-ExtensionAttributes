#!/bin/bash

#Script to detect if a computer has unknown local admin accounts
#Initialize array
declare -a admin_list=()
# Declare known admins
declare -a known_admins=('root' 'admin' 'mgmt_jamf' '' '' '' '' '')

# Add unknown admins users to array
function add_admins
{
        while [ $# -gt 0 ]
        do
                # Assume unknown until otherwise proven
                it_admin="FALSE"
                # Check admin aginst list of known admins
                # If known do not add to list
                for each_admin in "${known_admins[@]}"
                do
                        if [[ "$each_admin" == "$1" ]]
                        then
                                it_admin="TRUE"
                                break
                        fi
                done

                # If not known now add to list
                if [[ "$it_admin" == "FALSE" ]]
                then
                        admin_list+=($1)
                fi
                shift
                
                # If admin_list is null add "none"
                if [ "$admin_list" = "" ]
                then
                        admin_list="none"
                fi
        done
}

# Get admin user list and pass to function
add_admins `dscl . read /Groups/admin GroupMembership | cut -d ":" -f 2`

# Prints the array's list contents
echo "<result>$(printf '%s\n' "${admin_list[@]}")</result>"

exit 0
