#!/bin/sh
################################################################
# Make Current User aan Administrator						   #
################################################################

# Get Current Logged in User
curUser=`ls -l /dev/console | cut -d " " -f 4`

# Set User as Administrator
sudo dseditgroup -o edit -a $curUser -t user admin

exit 0