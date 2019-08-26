#!/bin/bash

sshTempUpdateFile="/tmp/tempRemoteUpdate-${CUSTOM_BUILD_NUMBER}.sh"
vJsonPropFile="TM-Properties.json"
vJsonParser="scripts/TM-JsonParser.sh"

source ${vJsonParser} ${vJsonPropFile}

vMail_admin=$(fnExtractJson mail_admin)
vMail_subject=$(fnExtractJson mail_subject)
vMail_list=$(fnExtractJson mail_list)
vTMTriggerPath="${WORKSPACE}/ivs-root/ivs-common/iSIM/nightly"
vISIMReportLocation="${HOME}/${vLinuxShareBase}/SCM/Automation/Artifacts/Reports/$(fnExtractJson build_type)/$(fnExtractJson GitRepositoryName)/${CUSTOM_BUILD_NUMBER}"
vMAIL_TEXT=${vISIMReportLocation}/$(fnExtractJson mail_text)
vMAIL_TEXT_SLACK="/tmp/${CUSTOM_BUILD_NUMBER}_slack_$(fnExtractJson mail_text)"
vJK_Publish_Report="$(fnExtractJson jk_url)/job/$(fnExtractJson jk_org)/job/$(fnExtractJson jk_repo)/job/$(fnExtractJson jk_branch)/${BUILD_NUMBER}/artifact/$(fnExtractJson mail_text)"


if [ -f ${vMAIL_TEXT} ]; then
	cat ${vMAIL_TEXT} > ${vMAIL_TEXT_SLACK}
	cp -v ${vMAIL_TEXT} "${WORKSPACE}"

	ls -l ${vMAIL_TEXT_SLACK}

	# Removing all the iTAF reports
	echo "Removing all the iTAF reports"
	sed -i '/ASDF/, $d' ${vMAIL_TEXT_SLACK}

	# Append the test artifacts report link
	echo -e "<p><b> Detailed iTAF report: </b> ${vJK_Publish_Report} <p>" >> ${vMAIL_TEXT_SLACK}

	echo -e "<p>" >> ${vMAIL_TEXT_SLACK}
	echo -e "Regards,<br>" >> ${vMAIL_TEXT_SLACK}
	echo -e "Automation Admin" >> ${vMAIL_TEXT_SLACK}
	echo -e "</p>" >> ${vMAIL_TEXT_SLACK}

	ls -l ${vMAIL_TEXT_SLACK}
else
	echo "Mail Template is missing !!"
	exit 1
fi
