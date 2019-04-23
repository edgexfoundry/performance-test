#!/bin/bash

if [[ `uname -m` != "x86_64" ]]
then
  sudo apt install -y --no-install-recommends docker-compose
else
  sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi
