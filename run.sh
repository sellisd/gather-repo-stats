#!/usr/bin/bash

# Script to run analysis

## Pre-requisites
# make sure docker is running `sudo docker-up` and in a new terminal run run.sh
# save in github PAT in /workspace/.github.env file

## Set-up environment
LOG_FILE=gather-repo-stats.log
RESULTS_LOCATION=/workspace # to persist in a gitpod
RESULTS_LOCATION=$HOME

## Build image
docker build -t gather-repo-stats .

## Run analysis and copy results locally
docker run -v ${RESULTS_LOCATION}/dockerresults/:/results --env-file ${RESULTS_LOCATION}/.github.env gather-repo-stats

## Save log with time stamp
echo "Analysis run on:" > $LOG_FILE
date >> $LOG_FILE

## once ready prepare to download data
gp url 8080 # where should the data be exposed
python3 -m http.server 8080
