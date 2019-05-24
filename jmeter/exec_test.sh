#!/bin/sh
echo "INFLUXDBHOST : "${INFLUXDBHOST}
{
    echo " Sending requests to node1 "
    # Execute time of each test script is 1h
    ## Core-Metadata
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-uploadprofile.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-uploadprofile.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node1} 
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-createaddressable.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-createaddressable.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node1} 
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-createdevice-single-deviceprofile.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-createdevice-single-deviceprofile.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node1} 
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-createdevice-multi-deviceprofile.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-createdevice-multi-deviceprofile.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node1} 
    
    ## Test script of Core-Data
    docker-compose run --rm jmeter -n -t script/testplan/core-data-sendingvaluedescription.jmx -q script/testplan/edgex.properties -l script/logs/core-data-sendingvaluedescription.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node1} 

    ## Test script of Core-Command
    docker-compose run --rm jmeter -n -t script/testplan/core-command-getDeviceCommand.jmx -q script/testplan/edgex.properties -l script/logs/core-command-getDeviceCommand.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node1}
    docker-compose run --rm jmeter -n -t script/testplan/core-command-getCommand-byDeviceID.jmx -q script/testplan/edgex.properties -l script/logs/core-command-getCommand-byDeviceID.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node1} 
    docker-compose run --rm jmeter -n -t script/testplan/core-command-getCommand-byDeviceName.jmx -q script/testplan/edgex.properties -l script/logs/core-command-getCommand-byDeviceName.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node1} 
} &
{ 
    sleep 20s
    echo " Sending requests to node2 "
    # Execute time of the test script is 24h
    docker-compose run --rm jmeter -n -t script/testplan/core-metadata-uploadprofile-24h.jmx -q script/testplan/edgex.properties -l script/logs/core-metadata-uploadprofile-24h.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node2} 
} &
{ 
    sleep 40s
    echo " Sending requests to node3 "
    # Execute time of the test script is 24h
    docker-compose run --rm jmeter -n -t script/testplan/core-data-sendingevent.jmx -q script/testplan/edgex.properties -l script/logs/core-data-sendingevent.jtl -J influxdbHost=${INFLUXDBHOST} -J test.machine=${node3}
}   
