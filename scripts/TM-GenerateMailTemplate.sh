#!/bin/bash

vOutputCfg=$1
vJsonPropFile="TM-Properties.json"
vJsonParser="scripts/TM-JsonParser.sh"
vMAIL_TEXT_TEMPLATE="${vOutputCfg}"

if [[ ${vOutputCfg} == "" ]]; then
	echo "The Mail Template name is empty !"
	exit 1
fi

source ${vJsonParser} ${vJsonPropFile}
vJK_PipelineLog="${BUILD_URL}console"

echo ${vJK_PipelineLog}

if [ -f ${vMAIL_TEXT_TEMPLATE} ]; then
    rm -v ${vMAIL_TEXT_TEMPLATE}
fi

# Header 
echo -e "<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN http://www.w3.org/TR/html4/loose.dtd>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<html>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<head><title></title>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "</head>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<body>" >> ${vMAIL_TEXT_TEMPLATE}

echo -e "<font color=white><b> TAF Manager Report </b></font><br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "</a>" >> ${vMAIL_TEXT_TEMPLATE}

echo -e "<p>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<font color="#003d99"><b> TAF execution</b></font><br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       iTAF-Duration <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Total-TestExecution <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Test-PassCount <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Test-FailCount <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Test-PassPercentage <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       ROBOT_STOP_ONFAIL:   $(fnExtractJson jk_robot_stop_onfail) <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "</p>" >> ${vMAIL_TEXT_TEMPLATE}

echo -e "<p><b> Test Reports:</b></p>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<p> Jenkins Log:  ${vJK_PipelineLog} </p>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<!ASDF>" >> ${vMAIL_TEXT_TEMPLATE}
