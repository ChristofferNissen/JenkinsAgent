#!/bin/bash
docker push stifstof/jnlp-base:latest stifstof/jnlp-base:$1
docker push stifstof/jnlp-slave-arm:latest stifstof/jnlp-slave-arm:$1
