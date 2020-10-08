
# Jenkins Agent

This repository is used by me personally on my Raspberry Pi cluster at home. The Jenkins Agent is build on the cluster to make it arm64 architecutre, however this does not have to be the case since the dockerfile can be build on amd64 and arm64.

## Use
The Jenkins Agent is used with Jenkins Kubernetes Plugin
Follow setup guide provided by Jenkins for setting up the plugin, however, use this image instead if you want:

### Installed Components

Docker Engine
Docker-Compose
Faas-cli

## Faas-cli git repo

Remember to clone faas-cli repo to docker-jenkins-agent folder
