#!/bin/bash

function download() {
    gitrepodb init --name ./repositories.db --overwrite \
        && gitrepodb query --project python --head 100 \
        && gitrepodb add --basepath /data/python \
        && gitrepodb query --project java --head 100 \
        && gitrepodb add --basepath /data/java/ \
        && gitrepodb query --project jupyter --head 100 \
        && gitrepodb add --basepath /data/jupyter \
        && gitrepodb download --project python \
        && gitrepodb download --project java \
        && gitrepodb download --project jupyter \
        && cp repositories.db /results/
}

function analyze() {
    cd /src/javacodeseq \
        && ./gradlew run --args='--input /data/java --output /results/java.tsv' \
        && pycodeseq --input_path /data/python --output /results/python.tsv --method levels \
        && pycodeseq --input_path /data/jupyter --output /results/jupyter.tsv --method cells
}

case "$1" in
    "download")
        download
        ;;
    "analyze")
        analyze
        ;;
    "all")
        download && analyze
        ;;
    *)
        echo "Usage: $0 {download|analyze|all}"
        exit 1
        ;;
esac