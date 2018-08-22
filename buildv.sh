#!/bin/bash -xel
xmlfile=$(curl -s "http://34.201.9.124:8080/job/test-project/$1/api/xml?/$1/api/xml?wrapper=changes&xpath=//changeSet//comment")
re="DEVTEST-([0-9])*"
if [[ $xmlfile =~ $re ]];
   then issueKey=${BASH_REMATCH[0]}
fi
re2="([0-9])+"
if [[ $issueKey =~ $re2 ]];
   then echo ISSUE_ID=${BASH_REMATCH[0]} > /tmp/env.properties
fi
