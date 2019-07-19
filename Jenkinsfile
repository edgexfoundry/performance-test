def node1 = ''
def node2 = ''
def node3 = ''
def isFinished = false

node ("${env.NODE_EDGEX_1}") {
	stage ('Node 1: Deploy services') {
		sh "pwd; ls"
		echo "WORKSPACE: $WORKSPACE"
		sh "cp telegraf/telegraf-template.conf telegraf/telegraf.conf"
		sh "sed -i 's/influxDBHost/${env.INFLUXDBHOST}/g; s/NODE/node-1/g' telegraf/telegraf.conf"
		sh "cat telegraf/telegraf.conf"
		// Install docker-compose
		sh './docker-compose-setup.sh'
                                    
                // Deploy edgeX
		sh 'cd telegraf; ./deploy-edgeX-Service.sh'
		sh 'docker logs telegraf'
		echo "Docker ps output:"
		sh 'docker ps'
                                    
		// Get client IP
		node1 = sh returnStdout: true, script: "hostname -i | tr ' ' '\n' | grep '^10.' | head -n 1"
		node1 = "${node1}".trim()
		echo "node1 IP: $node1"
	}

	stage ('Node 1: Keep alive for receiving requests') {
		waitUntil {
			script {
				return isFinished
                               }
                }
	}
}

node ("${env.NODE_TEST_HOST}") {

	environment { INFLUXDBHOST = "${env.INFLUXDBHOST}" }
	stage ('TE: Setup'){
		sh './docker-compose-setup.sh'
	}

	stage ('TE: Wait until all nodes deply completely') {
		waitUntil {
			script {
				return (node1 != '')
			}
		}
	}

	stage ('TE: Sending requests to all nodes - long run') {
		echo "node1 : ${node1}"
		try {
			withEnv(["node1=${node1}"]){
				echo "Details inside test host"
				sh 'ls; pwd; uname -a;'
				echo "Installing the tools"
				sh 'cd taf; ./updateme.sh'
				echo "Verifying pip package list"
				sh 'pip list'
				echo "The IP Address of the Appliance is ${node1}"
				echo "Check for lftools"
			}
		} finally {
			isFinished = true
		}
	}
}
