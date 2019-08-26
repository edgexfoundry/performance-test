#!/bin/bash

vJSON_CFG=$1
vJQ_DocImg="nexus3.edgexfoundry.org:10003/edgex-jq:arm64"

if [[ ! -f ${vJSON_CFG} ]]; then
	echo "Given JSON file is not present ! Terminating the execution"
	exit 1
fi

function fnExtractJson {
	temp=`docker run --rm -i ${vJQ_DocImg} ".$1" < ${vJSON_CFG} | sed s/\"//g`
	#temp=`docker run --rm -i jq_test  ".$1" < ${vJSON_CFG} | sed s/\"//g`
	echo ${temp}
}
