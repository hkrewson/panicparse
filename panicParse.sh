#!/bin/bash
panicList=($(mdfind *.panic))
for i in ${panicList[@]}; do
cat $i s sed 's/^.*\(Stackshot.*kexts:\).*$/\1/' | sed 's/\\n/\
 /g' | sed 's/\\/\
 /g'
done