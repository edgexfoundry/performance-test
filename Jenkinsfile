#!/usr/bin/env groovy
def node1 = ''
def node2 = ''
def node3 = ''
def isFinished = false

pipeline {
    agent none
    stages{
        stage ('Start Test'){
            parallel {
                stage ('Node 1') {
                    agent { label "${env.NODE_EDGEX_1}" }
                    stages {
                        stage ('Node 1: Deploy services') {
                            steps{
                                script {                                
                                    sh "sed 's/influxDBHost/'${env.INFLUXDBHOST}'/g; s/NODE/node-1/g' telegraf/telegraf-template.conf > telegraf/telegraf.conf"
                                    // Install docker-compose
                                    sh './docker-compose-setup.sh'
                                    
                                    // Deploy edgeX
                                    sh 'cd telegraf; ./deploy-edgeX-Service.sh'
                                    sh 'docker logs telegraf'
				    echo "Docker ps output:"
				    sh 'docker ps'
                                    
                                    // Get client IP
                                    node1 = sh(returnStdout: true, script: "hostname -i | tr ' ' '\n' | grep '^10.' | head -n 1")
                                    node1 = "${node1}".trim()
                                }
                            }
                        }
                        stage ('Node 1: Keep alive for receiving requests') {
                            steps{
                                script{
                                    waitUntil {
                                        script {
                                            return isFinished
                                        }
                                    }
                                }
                            }
                        }
                    }
                }     
                    
                stage ('Test Executor Progress') {
                    agent { label "${env.NODE_JMETER}" }
                    environment { INFLUXDBHOST = "${env.INFLUXDBHOST}" }
                    stages {
                        stage ('TE: Setup'){
                            steps {
                                script {
                                    sh './docker-compose-setup.sh'
                                }
                            }
                        }
                        stage ('TE: Wait until all nodes deply completely') {
                            steps {
                                script {
                                    waitUntil {
                                        script {
                                            return (node1 != '')
                                        }
                                    }                                    
                                }
                            }
                        }
                        stage ('TE: Sending requests to all nodes - long run') {
                            steps {
                                script {                                    
                                    echo "node1 : ${node1}"
                                    try {
                                        withEnv(["node1=${node1}","node2=${node2}","node3=${node3}"]){
					    echo "Details inside test host"
                                            sh 'ls; pwd; uname -a;'
					    echo "Installing the tools"
					    sh 'cd taf; ./updateme.sh'
					    echo "Verifying pip package list"
					    sh 'pip list'
					    echo "The IP Address of the Appliance is ${node1}"
					    echo "Check for lftools"
					    sh 'lftools -h'
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
    }
}
