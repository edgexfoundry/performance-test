#!/usr/bin/env sh
#This file is used to update your local OS environment to get project
#dependencies.
apt -y update
#sudo apt -y install python3.6
apt -y install python3-pip
apt -y install git
pip3 install -r requirements.txt
