#!/bin/bash
docker push stifstof/jnlp-base:latest
docker push stifstof/jnlp-base:$1

docker push stifstof/jnlp-slave-arm:latest
docker push stifstof/jnlp-slave-arm:$1
