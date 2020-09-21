#!/bin/bash
sudo docker build ./docker-jenkins-agnt -t stifstof/jenkins-agent-docker-arm:$1 -t stifstof/jenkins-agent-docker-arm:latest
