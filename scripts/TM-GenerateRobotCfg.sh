#!/bin/bash

vOutputCfg=$1
vJsonPropFile="TM-Properties.json"
vJsonParser="scripts/TM-JsonParser.sh"

if [[ ${vOutputCfg} == "" ]]; then
	echo "The Robot Cfg name is empty !"
	exit 1
fi

source ${vJsonParser} ${vJsonPropFile}


cat > ${vOutputCfg} <<EOF
#Auto generated project configurations
[Demo]
username=$(fnExtractJson robot_Demo_url_username)
loglevel=$(fnExtractJson robot_Demo_loglevel)
EOF
