#! /bin/bash

vOutputCfg=$1
vJsonPropFile="iSIM-Properties.json"
vJsonParser="scripts/iSIM-JsonParser.sh"
vMAIL_TEXT_TEMPLATE="${vOutputCfg}"

if [[ ${vOutputCfg} == "" ]]; then
	echo "The Mail Template name is empty !"
	exit 1
fi

source ${vJsonParser} ${vJsonPropFile}
vJK_PipelineLog="$(fnExtractJson jk_url)/blue/organizations/jenkins/$(fnExtractJson jk_org)%2F$(fnExtractJson jk_repo)/detail/$(fnExtractJson jk_branch)/${BUILD_NUMBER}/pipeline"

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

echo -e "<font color=white><b> iSIM Report </b></font><br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<a href=https://wiki.ith.intel.com/display/IVS/ISIM target=“_blank”>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<img src=http://iotg-dev30.ch.intel.com/Images/iSIMLogo.jpg alt=Header width=749 height=101>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "</a>" >> ${vMAIL_TEXT_TEMPLATE}

echo -e "<p>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<font color="#003d99"><b> iTAF execution</b></font><br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       iTAF-Duration <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Total-TestExecution <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Test-PassCount <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Test-FailCount <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Test-PassPercentage <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Device URL:  $(fnExtractJson robot_Login_url_base) <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Device OS:  $(fnExtractJson device_os) <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       SRC Tag: TAG_NA <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Device Inventory Branch: $(fnExtractJson device_invent_branch) <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Device Core Branch: $(fnExtractJson device_core_branch) <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Device Inventory GIT docker-compose version:  TBD_device_invent_git-tag <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Device Core GIT docker-compose version:  TBD_device_core_git-tag <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Version of context-broker:  TBD_context-broker <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Version of inventory-service:  TBD_inventory-service <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Version of mapping-sku-service:  TBD_mapping-sku-service <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Version of cloud-connector-service:  TBD_cloud-connector-service <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Version of rfid-gateway:  TBD_rfid-gateway <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Version of rfid-alert-service:  TBD_rfid-alert-service <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       Version of rfid-provider-service:  TBD_rfid-provider-service <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "       ROBOT_STOP_ONFAIL:   $(fnExtractJson jk_robot_stop_onfail) <br>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "</p>" >> ${vMAIL_TEXT_TEMPLATE}

echo -e "<p><b> Test Reports:</b></p>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<p> Jenkins Log:  ${vJK_PipelineLog} </p>" >> ${vMAIL_TEXT_TEMPLATE}
echo -e "<!ASDF>" >> ${vMAIL_TEXT_TEMPLATE}
