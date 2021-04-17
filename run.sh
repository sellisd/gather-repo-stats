#!/usr/bin/bash

# Script to run analysis

## Pre-requisites
# make sure docker is running `sudo docker-up` and in a new terminal run run.sh
# save github PAT in file `cat > /workspace/gather-repo-stats/.github.env`

## Set-up environment
LOG_FILE=gather-repo-stats.log
RESULTS_LOCATION=/workspace/gather-repo-stats # to persist in a gitpod
#RESULTS_LOCATION=$HOME

## Save log with time stamp
echo "Analysis started at:" > $LOG_FILE
date >> $LOG_FILE

## Build image
docker build -t gather-repo-stats .

## Run analysis and copy results locally
docker run -v ${RESULTS_LOCATION}/dockerresults/:/results --env-file ${RESULTS_LOCATION}/.github.env gather-repo-stats

echo "Analysis ended at:" >> $LOG_FILE
date >> $LOG_FILE

## once ready prepare to download data
gp url 8080 # where should the data be exposed
python3 -m http.server 8080
