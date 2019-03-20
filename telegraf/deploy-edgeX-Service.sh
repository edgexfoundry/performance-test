#!/bin/bash
# run env.sh to export environment variables

if [[ `uname -m` != "x86_64" ]]; then
	source arm64_env.sh
else
	source env.sh
fi

run_service () {
	echo "\033[0;32mStarting.. $1\033[0m"
	docker-compose up -d $1
}

# Performance test Service
run_service telegraf

# EdgeX Services
run_service volume
run_service consul

run_service config-seed

if [ "$SECURITY_SERVICE_NEEDED" = "true" ]; then

	run_service consul

	run_service vault

	run_service vault-worker

	run_service kong-db

	run_service kong-migration

	sleep 10s

	run_service kong

	sleep 10s

	run_service edgex-proxy
fi

run_service mongo

run_service logging

run_service notifications

run_service metadata

run_service data

run_service command

run_service scheduler

run_service export-client

run_service export-distro

#run_service rulesengine

#run_service device-virtual
