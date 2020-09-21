#!/bin/bash
docker build ./docker-jenkins-agent -t stifstof/jenkins-agent-docker-arm:$1 -t stifstof/jenkins-agent-docker-arm:latest
