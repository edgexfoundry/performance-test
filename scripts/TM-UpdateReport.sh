#!/bin/bash

vBuildNumber="${CUSTOM_BUILD_NUMBER}"
vJsonPropFile="TM-Properties.json"
vJsonParser="scripts/TM-JsonParser.sh"

source ${vJsonParser} ${vJsonPropFile}

vREPORT_TEXT=$(fnExtractJson report_text)

vExeTimeInSec=$@

if [[ ${vExeTimeInSec} == "" ]];then
	echo "Duration input is empty, terminating !"
	exit 1
fi

echo "Execution time: $vExeTimeInSec"

# Updating the Test execustion section
if [ -f ${vREPORT_TEXT} ]; then
    sed -i "s/iTAF-Duration/iTAF-Duration:  ${vExeTimeInSec}/" ${vREPORT_TEXT}
else
    echo "Report Template is missing !!"
    exit 1
fi
