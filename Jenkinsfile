#!/usr/bin/env groovy
def node1 = ''
def node2 = ''
def node3 = ''
def isFinished = false

pipeline {
    agent none
    stages{
	stage ('Test Only'){
	    agent { label "${env.NODE_EDGEX_1}" }
	    steps{
		script {
			echo ("Testing only for regression setup ")
		}
	    }
	}
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
                    
                stage ('JMeter Progress') {
                    agent { label "${env.NODE_JMETER}" }
                    environment { INFLUXDBHOST = "${env.INFLUXDBHOST}" }
                    stages {
                        stage ('JMeter: Setup'){
                            steps {
                                script {
                                    sh './docker-compose-setup.sh'
                                }
                            }
                        }
                        stage ('JMeter: Wait until all nodes deply completely') {
                            steps {
                                script {
                                    waitUntil {
                                        script {
                                            if ("${env.NODE_EDGEX_2}" == '') {
                                                node2 = "${node1}"
                                            } else {
                                            node2 = "${node2}"
                                            }
                                            if ("${env.NODE_EDGEX_3}" == '') {
                                                node3 = "${node1}"
                                            } else {
                                                node3 = "${node3}"
                                            } 
                                            return (node1 != '' && node2 != '' && node3 != '')
                                        }
                                    }                                    
                                }
                            }
                        }
                        stage ('JMeter: Sending requests to all nodes - long run') {
                            steps {
                                script {                                    
                                    echo "node1 : ${node1}"
                                    echo "node2 : ${node2}"
                                    echo "node3 : ${node3}"
                                    try {
                                        withEnv(["node1=${node1}","node2=${node2}","node3=${node3}"]){
                                            sh 'ls; pwd; uname -a;'
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
