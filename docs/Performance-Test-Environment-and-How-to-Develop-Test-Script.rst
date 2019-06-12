
Performance Test Environment and How to Develop Test Script
===========================================================

Environment
-----------

Setup Grafana, InfluxDB
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker-compose.yml
^^^^^^^^^^^^^^^^^^
The file is placed under grafana folder.

.. code-block:: none

  Version:3

  services:
    perf-grafana:
      image: grafana/grafana:5.4.3
      ports:
        - "3000:3000"
      container_name: perf-grafana
      hostname: perf-grafana
      networks:
        perf-network:
          aliases:
              - perf-grafana
              
    perf-influxdb:
      image: influxdb:1.7.3
      ports:
        - "8086:8086"
        - "2003:2003"
      container_name: perf-influxdb
      hostname: perf-influxdb
      networks:
        perf-network:
          aliases:
              - perf-influxdb
      volumes:
        - ./influxdb:/var/lib/influxdb

  networks:
    perf-network:
      driver: "bridge"

Note: Grafana and InfluxDB must be located on the same machine.

Create Databases on InfluxDB
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: none

  cherry@iotechwork:~/perf$ docker exec -it perf-influxdb influx
  Connected to http://localhost:8086 version 1.7.3
  InfluxDB shell version: 1.7.3
  Enter an InfluxQL query
  > create database jmeter
  > show databases
  name: databases
  name
  ----
  _internal
  telegraf
  jmeter

Grafana Configuration
^^^^^^^^^^^^^^^^^^^^^
1. Create DataSource to Telegraf and Jmeter:
  - Select data source type : InfluxDB
  - Input data source name : – Any recognized – 
  - URL : http://perf-influxdb:8086
  - Database : telegraf
  Note: For Jmeter, use jmeter instead of telegraf in Database.

2. Download dashboard from Grafana Labs and import to Grafana:
  - Jmeter monitoring (Datasource : jmeter): https://grafana.com/dashboards/4026 
  - docker metrics monitoring (Datasource : telegraf): https://grafana.com/dashboards/3467

3. Import jmeter monitoring dashbord Steps:
  - Open Grafana from browser by url http://$grafanahost:3000.
  - Login Grafana with admin user. (Default password:admin)
  - Click "+" icon > "Import" on left side.
  - Click Upload .json File and select the dashboard file of jmeter monitoring.
  - Select "jmeter" on data source field.
  - Click Import.
4. Import docker metrics monitoring dashbord Steps:
  - Open Grafana from browser by url http://$grafanahost:3000.
  - Login Grafana with admin user. (Default password:admin)
  - Click "+" icon > "Import" on left side.
  - Click Upload .json File and select the dashboard file of docker metrics monitoring.
  - Select "telegraf" on data source field.
  - Click Import.

5. After running the load test, view the Grafana dashboard. The dashboard will be similar to those illustrated below:

  .. figure:: screens/grafana-docker.png
    :alt: Docker metrics Dashboard
    :figwidth: 50%
    :align: center

    Docker metrics Dashboard

  .. figure:: screens/grafana-jmeter.png
    :alt: Jmeter Dashboard
    :figwidth: 50%
    :align: center

    Jmeter Dashboard

Setup Telegraf and all services
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker-compose.yml
^^^^^^^^^^^^^^^^^^
The file is placed under telegraf folder.

.. code-block:: none

  Version:3

  volumes:
    db-data:
    log-data:
    consul-config:
    consul-data:
    vault-config:  
    vault-file:
    vault-logs:

  services:
  
    <**edgeX services**>
              
    telegraf:
    image: cherrycl/telegraf
    container_name: telegraf
    hostname: telegraf
    networks:
      - perf-network
    volumes:
      - ${WORKSPACE}/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro
      - /var/run/docker.sock:/var/run/docker.sock
    privileged: true

  networks:
    perf-network:
      driver: "bridge"

telegraf.conf
^^^^^^^^^^^^
.. code-block:: none

  [[inputs.docker]]
    endpoint = "unix:///var/run/docker.sock"
    ## Monitor container to exclude or include.
    # container_name_exclude = [perf-telegraf,perf-grafana,perf-influxdb]
    container_name_include = ["edgex*"]
    container_name_exclude = ["edgex-files","edgex-core-config-seed"]
    timeout = "5s"
    perdevice = true
    ## Whether to report for each container total blkio and network stats or not
    total = false
    ## docker labels to include and exclude.
    ## Note that an empty array for both will include all labels as tags
    #docker_label_exclude = []
    docker_label_include = []
 
  [[outputs.influxdb]]
    urls = ["http://influxDBHost:8086"] # required
    database = "telegraf" # required
    retention_policy = ""
    write_consistency = "any"
    timeout = "5s"

Notes. 
  1. The value of **container_name_include** based on https://github.com/edgexfoundry/blackbox-testing/blob/master/docker-compose.yml.
  2. The value of **influxDBHost** on config file must be changed to host which has influxDB container.
  3. Telegraf and edgeX services must be located on the same machine.
  4. You can reference templated file, telegraf-template.conf, for telegraf.conf.
  


Setup Jmeter
~~~~~~~~~~~~
1. Make sure Java version 8 or above exists on the machine on which you want to setup Jmeter.
2. Download and setup Jmeter, for more information refer to https://jmeter.apache.org/usermanual/get-started.html#install
3. Install Property File Plugin to use custom properties on the GUI. This is required for GUI mode.
  - Get and install Property File Plugin from http://www.testautomationguru.com/jmeter-property-file-reader-a-custom-config-element/




Develop Test Script
-------------------

Develop Test Script using GUI mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Run Jmeter in GUI mode, for more information refer to https://jmeter.apache.org/usermanual/get-started.html#running
2. Repository Tree is as follows:
  .. code-block:: none

    Performance Root Folder
    │  Jenkinsfile
    │  docker-compose-setup.sh
    │
    ├─docs  *(documentation)
    │  │  Performance Test Environment and How to Develop Test Script.rst
    │  │
    │  └─screens
    │          grafana-docker.png
    │          grafana-import-dashboard-1.png
    │          grafana-jmeter.png
    │          jmeter-resultsample.png
    │          jmeter-threadsetting.png
    │
    ├─grafana
    │  │  docker-compose.yml
    │  │  env_setup.sh
    │  │  
    │  └─datasource
    │          jmeter-datasource.json
    │          telegraf-datasource.json
    │          
    ├─jmeter
    │  │  docker-compose.yml
    │  │  exec_test.sh
    │  │
    │  ├─image
    │  │      Dockerfile
    │  │      entrypoint.sh
    │  │
    │  └─script
    │       ├─testdata  *((Put all testdata on this folder))
    │       │  │  perf_sample_profile.yml
    │       │  │
    │       │  └─csv  *(Put all csv files on this folder which are used for test plan)
    │       │         cd-sendingevent-addressableName.csv
    │       │         cd-sendingevent-deviceName.csv
    │       │         cd-sendingevent-deviceProfileName.csv
    │       │         cd-sendingevent-deviceServiceName.csv
    │       │
    │       └─testplan  *(Put all test plan and property files on this folder)
    │                 core-data-sendingevent.jmx
    │                 core-metadata-createaddressable.jmx
    │                 core-metadata-uploadprofile.jmx
    │                 edgex.properties
    │
    └─telegraf
          arm64_env.sh
          deploy-edgeX-Service.sh
          docker-compose.yml
          env.sh
          telegraf-template.conf

Create Test Plan Steps
^^^^^^^^^^^^^^^^^^^^^^
1. Select **File > New** to create a new Test Plan.
2. Right-click and select **Test Plan name > Add > Config Element** to add the Property File Reader. Enter the property file in the File Path field.
3. Right-click and select **Test Plan name > Thread (Users)** and add setUp Thread Group to create data which is required for testing on next Thread Group.
4. Right-click and select **Test Plan name > Thread (Users)** and add Thread Group, which is main test group:
  - Right- click and select **Thread Group name > Listener**, and add Backend Listener to send request time to InfluxDB.
  - Right-click and select **Thread Group name > Sampler** and add HTTP Request, which is the main test API
  - Add PreProcessor, PostProcessor or any configuration required for testing. This depends on the requirements for each test case.
5. Right-click and select **Test Plan name > Thread (Users)** and add tearDown Thread Group to clean all data created by Thread Groups in the previous steps.
6. Right-click and select **Test Plan name > Listener** and add View Results Tree to view the request/response information.


Example: Upload Profile by UploadFile API
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Test cases: Upload five device profiles, combined file size around 500k, once each five seconds continuously for around one hour.

1. Create new Test Plan "Performance Test - Meatadata API".
2. Add Property File Reader, then enter "edgex.properties" in the File Path field.

  **edgex.properties**

  .. code-block:: none

      ##################################
      # Common Use
      ##################################
      influxdbHost = 35.229.240.174
      test.machine = 35.229.240.174

      ##################################
      # Core Metadata
      ##################################
      test.metadata.port=48081
       
      ##################################
      # Core Data
      ##################################
      test.coredata.port=48080
       
      ##################################
      # Core Command
      ##################################
      test.command.port=48082

3. Add Thread Group under Test Plan and configure is as illustrated below:
  .. figure:: screens/jmeter-threadsetting.png
    :figwidth: 50%
    :align: center

  - Add Backend Listener
      - Backend Listener implementation : org.apache.jmeter.visualizers.backend.influxdb.InfluxdbBackendListenerClient
      - influxdbUrl : http://${influxdbHost}:8086/write?db=jmeter
      - application : metadata    (-- Test Service --)
      - summaryOnly : false
      - Other fields    (-- You can leave to default value or add some information for the test api --)
  
  - Add HTTP request of Sampler which is main test API
      - Server Name or IP : ${__P(test.machine)}
      - Port Number : ${__P(test.metadata.port)}
      - Method : POST
      - Path : /api/v1/deviceprofile/uploadfile
      - Files Upload tab
      - File Path : ${testplandir}\..\testdata\perf_sample_profile.mod.${__threadNum}.yml
      - Parameter Name : file
      - MIME Type : application/x-yaml

  - Add PreProcessor to change profile name. (In this case, we always upload the same device profile, so change the profile name on every upload.)
  
    **PreProcessor - Change Profile Name**

    .. code-block:: groovy
      
      import org.apache.jmeter.services.FileServer
 
      //get current jmeter script's directory
      def path = FileServer.getFileServer().getBaseDir()
       
      // There are 5 users upload profile concurrently, new 5 device profiles and each user upload different file for avoiding conflict.
      profile_file= path + '/../testdata/perf_sample_profile.mod.'+ ${__threadNum} +'.yml'
      mod_profilename = "SensorTag-"+ ${__threadNum}${__time()}
      new File(profile_file).withWriter { w ->
        new File( path +'/../testdata/perf_sample_profile.yml' ).eachLine { line ->
          w << line.replaceAll( "%profile.name%", mod_profilename) + System.getProperty("line.separator")
        }
      }
       
      // set root folder to Global properties
      vars.put("testplandir", path)
      ${__setProperty(testplandir,${testplandir})}

  - Add PostProcessor to save device profile ID, which is returned on response body, for cleaning data on tearDown Thread Group

    **Save Device Profile ID**

    .. code-block:: groovy

      import org.apache.jmeter.services.FileServer
    
      //get current jmeter script's directory
      def path = FileServer.getFileServer().getBaseDir()
      def testdatapath=path + "/../testdata/csv/"
      
      new File(testdatapath + "res-deviceProfileID.csv") << prev.getResponseDataAsString() + System.getProperty("line.separator")

  - Add Constant Timer, by right-clicking and selecting HTTP Request > Timer, to wait 5 seconds (send once each 5 seconds)

3. Add tearDown Thread Group under Test Plan
  - Add CSV Data Set Config, by right-clicking and selecting **tearDown Thread Group > Config Element**, to read the csv file created above
    
    - Filename : ../testdata/csv/res-deviceProfileID.csv
    - Variable Names : deviceProfileID
    - Recycle on EOF : False
    - Stop thread on EOF : True
    - Sharing mode : Current thread group
    - Other fields stay to default value.
  - Add HTTP request of Sampler to delete all data created on thread group.
    
    - Server Name or IP : ${__P(test.machine)}
    - Port Number : ${__P(test.metadata.port)}
    - Method : DELETE
    - Path : /api/v1/deviceprofile/id/${deviceProfileID} ("deviceProfileID" has to the same as Variable Names which set on CSV Data Set Config)

4. Add setUp Thread Group under Test Plan, to delete csv file created on last run
  - Add JSR223 Sampler (you can use any sampler that meets the requirement) 
  
    **Clean res-devicePrifleID.csv**

    .. code-block:: groovy

      import org.apache.jmeter.services.FileServer
 
      //get current jmeter script's directory
      def path = FileServer.getFileServer().getBaseDir()
      def testdatapath= path + "/../testdata/csv/"

      new File(testdatapath + "res-deviceProfileID.csv").delete()

5. Only for the develop test script, add View Results Tree. Run the test in the GUI to see the result, as illustrated below: 
  .. figure:: screens/jmeter-resultsample.png
    :figwidth: 50%
    :align: center


Run Test Using Non-GUI Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**$ jmeter -n -t test_plan.jmx -q propertfile.properties -l logfile.jtl**



Notice for Jmeter Script
~~~~~~~~~~~~~~~~~~~~~~~~~
*Please ensure the Property File Reader is removed from the testplan, if your commit contains testplan.*