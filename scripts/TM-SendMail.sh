#! /bin/bash

vBuildNumber="${CUSTOM_BUILD_NUMBER}"
sshTempUpdateFile="/tmp/tempRemoteUpdate-${CUSTOM_BUILD_NUMBER}.sh"
vJsonPropFile="iSIM-Properties.json"
vJsonParser="scripts/iSIM-JsonParser.sh"

source ${vJsonParser} ${vJsonPropFile}

vMail_admin=$(fnExtractJson mail_admin)
vMail_subject="[${CUSTOM_BUILD_NUMBER}] $(fnExtractJson mail_subject)"
vMail_list=$(fnExtractJson mail_list)
vMail_list_slack=$(fnExtractJson mail_list_slack)
vISIMTriggerPath="${WORKSPACE}/ivs-root/ivs-common/iSIM/nightly"
vLinuxShareBase=$(fnExtractJson linux_share_base)
vISIMReportLocation="${HOME}/${vLinuxShareBase}/SCM/Automation/Artifacts/Reports/$(fnExtractJson build_type)/$(fnExtractJson GitRepositoryName)/${CUSTOM_BUILD_NUMBER}"
vMAIL_TEXT=${vISIMReportLocation}/$(fnExtractJson mail_text)
vMAIL_TEXT_SLACK="/tmp/${CUSTOM_BUILD_NUMBER}_slack_$(fnExtractJson mail_text)"

vExeTimeInSec=$@

if [[ ${vExeTimeInSec} == "" ]];then
	echo "Duration input is empty, terminating !"
	exit 1
fi

echo "Execution time: $vExeTimeInSec"

# Updating the Test execustion section
if [ -f ${vMAIL_TEXT} ]; then
    sed -i "s/iTAF-Duration/iTAF-Duration:  ${vExeTimeInSec}/" ${vMAIL_TEXT}
else
    echo "Mail Template is missing !!"
    exit 1
fi

if [ -f ${vMAIL_TEXT_SLACK} ]; then
    sed -i "s/iTAF-Duration/iTAF-Duration:  ${vExeTimeInSec}/" ${vMAIL_TEXT_SLACK}
else
    echo "Mail Template is missing !!"
    exit 1
fi

echo "Sending mails with test reports and logs"
mail -a "From: ${vMail_admin}" -a "MIME-Version: 1.0" -a "Content-Type: text/html" -s "${vMail_subject}" ${vMail_list} < ${vMAIL_TEXT}

echo "Sending mail to slack recipient "
mail -a "From: ${vMail_admin}" -a "MIME-Version: 1.0" -a "Content-Type: text/html" -s "${vMail_subject}" ${vMail_list_slack} < ${vMAIL_TEXT_SLACK}

