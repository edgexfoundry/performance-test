#! /bin/bash

vBuildNumber="${CUSTOM_BUILD_NUMBER}"
sshTempUpdateFile="/tmp/tempRemoteUpdate-${CUSTOM_BUILD_NUMBER}.sh"
vJsonPropFile="iSIM-Properties.json"
vJsonParser="scripts/iSIM-JsonParser.sh"

source ${vJsonParser} ${vJsonPropFile}

vLinuxShareBase=$(fnExtractJson linux_share_base)
vISIMReportBase="${HOME}/${vLinuxShareBase}/SCM/Automation/Artifacts/Reports/$(fnExtractJson build_type)/$(fnExtractJson GitRepositoryName)"

echo "Cleaning up folder older than 30 days..."
find ${vISIMReportBase}/* -type d -ctime +30 | xargs rm -rf
echo "Removing temporary files"
rm -v /tmp/tempRemote*
echo "Teardown completed"
