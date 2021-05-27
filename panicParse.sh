#!/bin/bash
# 
# Copyright 2021 Hamlin Krewson
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# 	limitations under the License.
#	
#################################### README ####################################
# While trying to read through panic logs, I'd found the easiest way was to 
#	copy and paste everything into an online xml formatter. I wanted an 
#	easier, simpler solution that I could do via Mosyle (or any remote shell 
#	command solution).
#
# With a lot of trial and error, some google-fu, and a few rounds at the game 
#	of head-meets-brick-wall, I came up with the following:
# cat $i s sed 's/^.*\(Stackshot.*kexts:\).*$/\1/' | sed 's/\\n/\
#/g' | sed 's/\\/\
#/g'
# 
# While this works, it does leave some thing to be desired. Missing the days 
#	of easily readable panics, and because of a request in MacAdmins 
# 	watchmanmonitoring channel I was inspired to do this. It works great with 
#	the text of a panic I had from Catalina. 
#
# Assuming you have Watchman Monitoring running, you could have a group set up 
#	in MDM based on having located kernel panics through that service.
#	See the related 'getWMPanicCount.sh'
###################################### END #######################################

# We need to adjust the field separator.
IFSOLD=$IFS
IFS=$'\n' 


# Now we need to search for panic logs.
# Panics are located in:
#	~/Library/Logs/DiagnosticLogs
#	~/Library/Logs/DiagnosticLogs/Retired
#	/Library/Logs/DiagnosticLogs
#	/Library/Logs/DiagnosticLogs/Retired
panicList=($(mdfind 'kMDItemFSName == *.panic'))

# An alternative method with find might look like
# panicList=($(find /Library/Logs/DiagnosticLogs /Users/localuser/Library/Logs/DiagnosticLogs -name "*.panic" 2>/dev/null))

# We're done with the field separator, returning it to normal
IFS=$IFSOLD

# Test the list if needed
#printf '%s\n' ${panicList[@]}

panicText={}
panicString={}
panicCount=1
# Doing the things! We'll first check that we have caught something.
if [[ "${#panicList[@]}" > 1  ]]; then
	# In our list of panics, we need to parse out relevant info
	for i in "${panicList[@]}"; do
		# panicText grabs everything from 'Stackshot' up to 
		#	'Loaded kexts'
		# panicString grabs the macOSPanicString
		panicFullText=$(cat "$i" | sed 's/^.*\(Stackshot.*kexts:\).*$/\1/')
		panicText=$(echo $panicFullText | sed 's/^.*\(Backtrace.*kexts:\).*$/\1/' | sed 's/loaded\ kexts://g')
		panicString=$(echo "$panicFullText" | sed 's/^.*\(macOSPanicString.*Backtrace\).*$/\1/')
		
		# Print a header
		perl -E "print '#' x 20; print ' PANIC '; print $panicCount; print ' '; print '#' x 20"
		printf '\n\n'
		
		# Print the macOS Panic String. 
		# IMPORTANT: Do NOT reformat the following!
		echo $panicString | sed 's/\":\"/\
	/g' | sed 's/\\//g' | sed 's/:\ \"/\
		/g' | sed 's/\"\@/\
		\@/g' | sed 's/Backtrace//g'
		
		printf '\n\n'
		
		# Parse the panicText and make it human readable
		echo "$panicText" | sed 's/\\n/\
 /g' | sed 's/\\/\
 /g' 
		# Separate multiple panics out.
		perl -E "print '#' x 20; print ' END PANIC '; print $panicCount; print ' '; print '#' x 20"
		printf '\n\n'
		panicCount=$(($panicCount + 1))
		
	done
fi