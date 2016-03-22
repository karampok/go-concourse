#!/bin/bash

#fly login -t srvci
echo 'y' | fly -t lite destroy-pipeline -p gocf
echo 'y' | fly -t lite sp -c pipe2.yml -p gocf -l ./ci/.credentials.yml 
fly -t lite unpause-pipeline -p gocf
fly -t lite pipelines
