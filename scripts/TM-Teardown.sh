#!/bin/bash

vBuildNumber="${CUSTOM_BUILD_NUMBER}"
sshTempUpdateFile="/tmp/tempRemoteUpdate-${CUSTOM_BUILD_NUMBER}.sh"
vJsonPropFile="TM-Properties.json"
vJsonParser="scripts/TM-JsonParser.sh"

source ${vJsonParser} ${vJsonPropFile}

## Cleanup code

echo "Teardown completed"
