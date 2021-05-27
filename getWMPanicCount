#!/bin/bash
# Watchman Monitoring keeps track of Kernel Panics
#	Check for the quanity of currently tracked panic logs

# Get the kernel panic count
panicCount=$(/usr/libexec/PlistBuddy -c 'print :Last_Panic_Count' /Library/MonitoringClient/PluginSupport/check_panic_count_settings.plist)


# If there are panics recorded, print the count and the recorded dates
if [[ $panicCount == *"Does Not Exist"* ]]; then 
	echo "<result>No Panics</result>"
else 
	echo "Panic Count: "$panicCount
	i=0
    panicResults=()
    while [ $i -lt $panicCount ]; do
    		panicResults+=("$(echo "Panic Date: " $(/usr/libexec/PlistBuddy -c "print :Panic_List:$i" /Library/MonitoringClient/PluginSupport/check_panic_count_settings.plist | xargs date -r))")
        	echo ${panicResults[$i]}
		i=$(($i + 1))     
	done
	
fi
