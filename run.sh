# Script to run analysis

# Set-up environment
LOG_FILE=gather-repo-stats.log
RESULTS_LOCATION=/workspace/dockerresults/ # to persist in a gitpod

## Build image
docker build -t grdb .

## Run analysis and copy results locally
docker run -v $RESULTS_LOCATION:/results  --env-file ~/.github.env grdb

## Save log with time stamp
echo "Analysis run on:" > $LOG_FILE
date >> $LOG_FILE

## once ready prepare to download data
gp url 8080 # where should the data be exposed
python3 -m http.server 8080
