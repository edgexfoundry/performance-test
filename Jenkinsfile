#!/usr/bin/env groovy
def slave1 = ''
def slave2 = ''
def slave3 = ''
def isFinished = false

pipeline {
    agent none
    
    stages {
        stage ('Run Test'){
            parallel {
                stage ('== EdgeX Host 1 ==') {
                    agent { label "${env.NODE_EDGEX_1}" }
                    steps{
                        script {
                            
                            sh "sed 's/influxDBHost/'${env.INFLUXDBHOST}'/g; s/NODE/node-1/g' telegraf/telegraf.conf.tmp > telegraf/telegraf.conf"
                            // Install docker-compose
                            sh './docker-compose-setup.sh'
                            
                            // Deploy edgeX
                            sh 'cd telegraf; ./deploy-edgeX-Service.sh'
                            sh 'docker logs telegraf'
                            
                            // Get client IP
                            slave1 = sh(returnStdout: true, script: "hostname -i | tr ' ' '\n' | grep '^10.' | head -n 1")
                            slave1 = "${slave1}".trim()

                            // Wait until JMeter script is done
                            waitUntil {
                                script {
                                    return isFinished
                                }
                            }
                        }
                    }
                }     
                
                stage ('== EdgeX Host 2 ==') {
                    when {
                        expression{
                            return "${env.NODE_EDGEX_2}" !=''}
                    }
                    agent { label "${env.NODE_EDGEX_2}" }
                    steps{
                        script {
                            
                            sh "sed 's/influxDBHost/'${env.INFLUXDBHOST}'/g; s/NODE/node-2/g' telegraf/telegraf.conf.tmp > telegraf/telegraf.conf"
                            // Install docker-compose
                            sh './docker-compose-setup.sh'
                            
                            // Deploy edgeX
                            sh 'cd telegraf; ./deploy-edgeX-Service.sh'

                            // Get client IP
                            slave2 = sh(returnStdout: true, script: "hostname -i | tr ' ' '\n' | grep '^10.' | head -n 1")
                            slave2 = "${slave2}".trim()

                            // Wait until JMeter script is done                            
                            waitUntil {
                                script {
                                    return isFinished
                                }
                            }
                        }
                    }
                }

                stage ('== EdgeX Host 3 ==') {
                    when {
                        expression{
                            return "${env.NODE_EDGEX_3}" !=''}
                    }
                    agent { label "${env.NODE_EDGEX_3}" }
                    steps{
                        script {
                            sh "sed 's/influxDBHost/'${env.INFLUXDBHOST}'/g; s/NODE/node-3/g' telegraf/telegraf.conf.tmp > telegraf/telegraf.conf"

                            // Install docker-compose
                            sh './docker-compose-setup.sh'
                            
                            // Deploy edgeX
                            sh 'cd telegraf; ./deploy-edgeX-Service.sh'

                            // Get client IP
                            slave3 = sh(returnStdout: true, script: "hostname -i | tr ' ' '\n' | grep '^10.' | head -n 1")
                            slave3 = "${slave3}".trim()

                            // Wait until JMeter script is done
                            waitUntil {
                                script {
                                    return isFinished
                                }
                            }
                        }
                    }
                }

                stage ('== Start Test - JMeter ==') {
                    agent { label "${env.NODE_JMETER}" }
                    environment { 
                            INFLUXDBHOST = "${env.INFLUXDBHOST}"
                    }
                    steps {
                        script {
                            // Install docker-compose
                            sh './docker-compose-setup.sh'

                            // Wait until all edgeX clients are started
                            waitUntil {
                                script {
                                    if ("${env.NODE_EDGEX_2}" == '') {
                                        slave2 = "${slave1}"
                                    } else {
                                        slave2 = "${slave2}"
                                    }
                                    if ("${env.NODE_EDGEX_3}" == '') {
                                        slave3 = "${slave1}"
                                    } else {
                                        slave3 = "${slave3}"
                                    } 
                                    return (slave1 != '' && slave2 != '' && slave3 != '')
                                }
                            }
                            echo "slave1 : ${slave1}"
                            echo "slave2 : ${slave2}"
                            echo "slave3 : ${slave3}"
                            // Execute JMeter scripts
                            try {
                                withEnv(["slave1=${slave1}","slave2=${slave2}","slave3=${slave3}"]){
                                    sh 'cd jmeter; sh ./exec_test.sh'
                                }
                            } finally {
                                isFinished = true
                            }
                        }
                    }
                }
            }
        }
    }
}
