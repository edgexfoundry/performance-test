#! /bin/bash

vOutputCfg=$1
vJsonPropFile="TM-Properties.json"
vJsonParser="scripts/TM-JsonParser.sh"

if [[ ${vOutputCfg} == "" ]]; then
	echo "The Project Cfg name is empty !"
	exit 1
fi

source ${vJsonParser} ${vJsonPropFile}

echo ${BUILD_NUMBER}
echo ${WORKSPACE}
echo ${BUILD_DISPLAY_NAME}
echo ${CUSTOM_BUILD_NUMBER}

## TEMP
#WORKSPACE="/home/vspremax/workspace/edgex/fork/performance-test"
#CUSTOM_BUILD_NUMBER="12345"

cat > ${vOutputCfg} <<EOF
#Auto generated project configurations
UC_NAMES=$(fnExtractJson uc_names)
PROFILE_NAMES=$(fnExtractJson profile_names)
DISABLE_PROXY=$(fnExtractJson DISABLE_PROXY)
DISPLAY_ENABLED=$(fnExtractJson DISPLAY_ENABLED)
DOXY_CONF_FILE=$(fnExtractJson doxygen_conf)
GIT_REPO_NAME=$(fnExtractJson GitRepositoryName)
ROBOT_TAG=$(fnExtractJson robot_tag)
ROBOT_CFG_FILTER=$(fnExtractJson robot_cfg_filter)
ROBOT_STOP_ONFAIL=$(fnExtractJson jk_robot_stop_onfail)
ROBOT_RETRY_ONFAIL=$(fnExtractJson jk_robot_retry_onfail)
ROBOT_RETRY_COUNT=$(fnExtractJson jk_robot_retry_count)
GIT_SERVER=$(fnExtractJson git_url)
JK_CHECKOUT_DIR=${WORKSPACE}/evs-root
JK_BUILD_NUMBER=${CUSTOM_BUILD_NUMBER}
EOF
