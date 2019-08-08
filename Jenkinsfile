#!/usr/bin/env groovy
def node1 = ''
def isFinished = false

// -----------------------  Global Variables -------------------- //

def v_Git_TAF_Server = ''
def v_Git_TAF_Repo = ''
def v_Git_TAF_RepoBranch = ''
def v_Git_TC_Server = ''
def v_Git_TC_Repo = ''
def v_Git_Org = ''

// Path defs
def v_EVS_Root = ''
def v_TM_Path = ''
def v_TM_Trigger_Path = ''
def v_TM_Utils_Path = ''
def v_TAF_Path = ''
def v_TAF_Cfg_Path = ''
def v_TAF_Artifacts_Path = ''
def v_TM_ReportTemplate = ''

loadGlobalLibrary()

pipeline {
    agent none

    options {
        timestamps()
    }

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
                                    sh './scripts/docker-compose-setup.sh'
                                    
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
                    agent { label "${env.NODE_TEST_HOST}" }
                    environment { INFLUXDBHOST = "${env.INFLUXDBHOST}" }
                    stages {

			stage ('Init') {
			    steps {
				script {
				    tafBuildNum = generateBuildNumber()
				    echo "tafBuildNum: $tafBuildNum"
				    env.CUSTOM_BUILD_NUMBER = "${tafBuildNum}-${env.BUILD_NUMBER}"
				    def jsonProp = readJSON file:'TM-Properties.json'
				    v_Git_TAF_Server = jsonProp.git_url
				    v_Git_TAF_Repo = jsonProp.git_taf_repo
				    v_Git_TAF_RepoBranch = jsonProp.git_branch
				    v_Git_TC_Server = "${v_Git_TAF_Server}"
				    v_Git_TC_Repo = jsonProp.git_tc_repo
				    v_Git_Org = jsonProp.git_org

				    // Path defs
				    v_EVS_Root = "${env.WORKSPACE}/evs-root"
				    v_TM_Path = "${v_EVS_Root}/${v_Git_TC_Repo}/TAF-Manager"
				    v_TM_Trigger_Path = "${v_TM_Path}/trigger"
				    v_TM_Utils_Path = "${v_TM_Path}/utils"
				    v_TAF_Path = "${v_EVS_Root}/TAF"
				    v_TAF_Cfg_Path = "${v_TAF_Path}/config"
				    v_TAF_Artifacts_Path = "${v_TAF_Path}/testArtifacts"
				    v_TM_ReportTemplate = jsonProp.mail_text
				    echo "v_Git_TAF_Server: ${v_Git_TAF_Server}"
				}
			    }
			}

			stage ('VCS') {
			    steps {
				dir('evs-root') {
				    git branch: 'master',
					url: "https://${v_Git_TAF_Server}/${v_Git_Org}/${v_Git_TAF_Repo}.git"
				    dir("${v_Git_TC_Repo}") {
					git branch: 'master',
					    url: "https://${v_Git_TC_Server}/${v_Git_Org}/${v_Git_TC_Repo}.git"
				    }
				}
				script {
				    sh 'ls -l evs-root'
				    sh 'echo "WORKSPACE: $WORKSPACE"'
				    sh 'echo "The custom build number is: [$CUSTOM_BUILD_NUMBER]"'
				}
			    }
			}
                        stage ('TM: Docker Setup'){
                            steps {
                                script {
                                    sh 'scripts/docker-compose-setup.sh'
//				    sh 'echo "Docker build for jq"'
//				    sh 'docker build -t jq_test .'
                                }
                            }
                        }

                        stage ('TM: Config Generation'){
                            steps {
                                script {
				    echo "In Config Generation"
                                    sh "scripts/TM-GenerateProjectCfg.sh ${v_TM_Trigger_Path}/${v_Git_TAF_Repo}.conf"
				    sh "cat ${v_TM_Trigger_Path}/${v_Git_TAF_Repo}.conf"
				    sh "scripts/TM-GenerateMailTemplate.sh ${v_TM_Trigger_Path}/${v_TM_ReportTemplate}"
				    sh "scripts/TM-GenerateRobotCfg.sh ${v_TAF_Cfg_Path}/platform.cfg"
                                }
                            }
                        }

                        stage ('TM: Robot execution') {
                            steps {
                                script {                                    
                                    echo "Node to be tested : ${node1}"
				    withEnv(["node1=${node1}"]){
					def v_Report = "${v_TAF_Artifacts_Path}/${CUSTOM_BUILD_NUMBER}"
					echo "Test host details:"
                                        sh 'uname -a'
					echo "Installing the tools"
					sh "cd ${v_EVS_Root}; sudo ./updateme.sh"
//					sh "cd taf; chmod +x ${v_TM_Trigger_Path}/TM-Trigger.sh; sudo ./updateme.sh"
					echo "Test execution on: ${env.SILO}"
					sh "bash ${v_TM_Trigger_Path}/TM-Trigger.sh ${v_TM_Trigger_Path}/${v_Git_TAF_Repo}.conf"
					sh "ls ${v_TAF_Artifacts_Path}"
					sh "[ -d ${v_Report} ] && zip -r ${v_TAF_Artifacts_Path}/artifacts.zip ${v_Report}"
                                    }
                                }
                            }
			}

			stage ('TM: Orchestration') {
			    steps {
				script {
				    try {
					echo "Orchestration of TAF artifacts to Nexus repository"
					edgeXNexusPublish([
					    serverId: 'nexus.edgexfoundry.org',
					    mavenSettings: 'taf-test-settings',
					    nexusRepo: 'taf-test',
					    zipFilePath: '**/testArtifacts/*.zip'
					])
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

// EdgeX Nexus publish
def loadGlobalLibrary(branch = '*/master') {
    library(identifier: 'edgex-global-pipelines@master', 
        retriever: legacySCM([
            $class: 'GitSCM',
            userRemoteConfigs: [[url: 'https://github.com/edgexfoundry/edgex-global-pipelines.git']],
            branches: [[name: branch]],
            doGenerateSubmoduleConfigurations: false,
            extensions: [
                [$class: 'SubmoduleOption', recursiveSubmodules: true],
                [$class: 'IgnoreNotifyCommit']
            ]
        ])
    )
}

// Function definition to generate the random number
def generateBuildNumber() {
    sh(script: 'echo $((1 + RANDOM % 1000 + 1000000))', returnStdout: true).trim()
}
