#!/bin/sh
# Checks to See if Current Session Has Used a Filevault Recvoery Key to Login in with.
# Created by Gavin Pardoe - 25-01-2016
# Created for use with Casper Suite, to used in conjunction with a LunchDaemon, Casper Extension
# Attribute & Policy.

# Create Log File and Set Variables
	dateTime=`/bin/date "+%Y-%m-%d %H:%M"`
	/usr/bin/touch /var/log/$logFileName
	logFilePath=/var/log/$logFileName

# Checking Login Status
  if [[ "/usr/bin/fdesetup usingrecoverykey" != false ]]; then
    /usr/bin/touch "/Library/Application Support/JAMF/fvKeyUsed"
    echo "Logged in Using Recovery Key - fvKeyUsed Recipet Created: $dateTime" >> $logFilePath
    exit 0
  else
    echo "Logged in Using Password"
    exit 0
    fi
