#
# Copyright (c) 2021 Hamlin Krewson
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
################################# DESCRIPTION #################################
# 
#	This script looks for Kernel Panics on macOS 10.12 or later.
#
#################################### TO DO ####################################
#
#
################################## VARIABLES ##################################


################################## FUNCTIONS ##################################
function result(){
	# For Jamf Pro the following should be uncommented
	echo "<result>$1</result>"
	
	#for Mosyle, the following should be uncommented
	#printf "$1"
}


# Do things. Send output to the result() function. 
#	result "my intended extension attribute info"
################################### Examples ##################################
#IFSOLD=$IFS
#IFS=$'\n'
#hasAppSaved=($(mdfind "AppName.app"))
#for i in $hasAppSaved; do
#	if [[ "$i" =~ ".app" ]]; then
#		result "$i"
#	fi
#done


panicList=($(mdfind 'kMDItemFSName == *.panic'))
result ${#panicList[@]}
