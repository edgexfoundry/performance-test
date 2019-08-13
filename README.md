#  Regression Pipeline Overview

This pipeline uses Jenkins as its code pipeline, few components are explained below

*	Jekinsfile - a build descriptor written in the the Groovy programming language committed into the source repository that describes how the code will be built.
    * Stage - User defined sequential steps of a job. For example, the test stage, build stage, etc.
*	iSIM Parameters – A JSON file which contains the key-value pair as a parameter to the pipeline which will be parsed during the execution.

*	Staging scripts – Bunch of scripts to implement the stage.

*	TAF - Test and Automation Framework is a test automation code specific to the project, contains set of python routines wrapped within robot framework. 
*	TAF-Common – this is the common repository contains the code, scripts, simulators that are to be used in all the projects.
