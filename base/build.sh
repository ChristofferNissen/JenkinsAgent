#!/bin/bash
docker build -f ./base/Dockerfilebase -t stifstof/jnlp-base:latest -t stifstof/jnlp-base:$1 ./base
docker build ./base -t stifstof/jnlp-slave-arm:latest -t stifstof/jnlp-slave-arm:$1
