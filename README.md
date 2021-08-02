# EdgeX Foundry Proformance Tests
[![Build Status](https://jenkins.edgexfoundry.org/view/EdgeX%20Foundry%20Project/job/edgexfoundry/job/performance-test/job/main/badge/icon)](https://jenkins.edgexfoundry.org/view/EdgeX%20Foundry%20Project/job/edgexfoundry/job/performance-test/job/main/) [![GitHub Pull Requests](https://img.shields.io/github/issues-pr-raw/edgexfoundry/performance-test)](https://github.com/edgexfoundry/performance-test/pulls) [![GitHub Contributors](https://img.shields.io/github/contributors/edgexfoundry/performance-test)](https://github.com/edgexfoundry/performance-test/contributors) [![GitHub Committers](https://img.shields.io/badge/team-committers-green)](https://github.com/orgs/edgexfoundry/teams/performance-test-committers/members) [![GitHub Commit Activity](https://img.shields.io/github/commit-activity/m/edgexfoundry/performance-test)](https://github.com/edgexfoundry/performance-test/commits)



## Folder structure
- grafana folder : Only use when running on local grafana.

- telegraf folder : Start telegraf and edgeX services.

- jmeter folder : Run jmeter script.

  - image folder : Use for build JMeter 
  image. 
  - script folder : jmeter test scripts and data.




#### Notice for Jmeter Script
*If your commit contains testplan, please ensure the Property File Reader is removed from the testplan.*

## Local develop
Please refer to the [documentation in the repository](docs/Performance-Test-Environment-and-How-to-Develop-Test-Script.rst) for details.


