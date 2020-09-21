#!/bin/bash
docker build -f Dockerfilebase -t stifstof/jnlp-base:latest .
docker build . -t stifstof/jnlp-slave-arm:latest
