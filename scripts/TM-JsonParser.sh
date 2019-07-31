#! /bin/bash

vJSON_CFG=$1

if [[ ! -f ${vJSON_CFG} ]]; then
	echo "Given JSON file is not present ! Terminating the execution"
	exit 1
fi

function fnExtractJson {
	temp=`docker run --rm -i imega/jq  ".$1" ${vJSON_CFG} | sed s/\"//g`
	echo ${temp}
}
