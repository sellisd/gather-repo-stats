FROM python:3.13-slim

# get required packages and tools
RUN apt-get update \
    && apt-get install -y git wget
ENV JAVA_HOME=/opt/jdk-11.0.10+9
ENV PATH=$JAVA_HOME/bin:$PATH
RUN wget https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.10_9.tar.gz
RUN tar -xzvf OpenJDK11U-jdk_x64_linux_hotspot_11.0.10_9.tar.gz -C /opt/

# make dir structure
RUN mkdir -p /src
RUN mkdir -p /data
RUN mkdir -p /results

# clone/install software
WORKDIR /src
RUN git clone --depth 1 https://github.com/sellisd/gitrepodb.git \
    && git clone --depth 1 https://github.com/sellisd/javacodeseq.git \
    && python -m pip install clone git+https://github.com/sellisd/pycodeseq.git@main
WORKDIR /src/gitrepodb
RUN pip install .
WORKDIR /data/results

# Get repositories and Run analysis
CMD gitrepodb init --name ./repositories.db --overwrite \
    && gitrepodb query --project python --head 10 \
    && gitrepodb add --basepath /data \
    && gitrepodb query --project java --head 10 \
    && gitrepodb add --basepath /data \
    && gitrepodb query --project jupyter --head 10 \
    && gitrepodb add --basepath /data \
    && gitrepodb download --project python \
    && gitrepodb download --project java \
    && gitrepodb download --project jupyter \
    && cp repositories.db /results/ \
    && cd /src/javacodeseq \
    && ./gradlew run --args='--input /data --output /results/java.tsv' \
    && pycodeseq --input_path /data --output /results/python.tsv --method levels \
    && pycodeseq --input_path /data --output /results/jupyter.tsv --method cells
