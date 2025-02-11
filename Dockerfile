FROM python:3.13-slim
ENV LC_ALL C.UTF-8
# get required packages and tools
RUN apt-get update \
    && apt-get install -y git wget
ENV JAVA_HOME=/opt/jdk-21.0.6+7
ENV PATH=$JAVA_HOME/bin:$PATH
RUN wget https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.6_7.tar.gz \
    && tar -xzvf OpenJDK21U-jdk_x64_linux_hotspot_21.0.6_7.tar.gz -C /opt/ \
    && rm OpenJDK21U-jdk_x64_linux_hotspot_21.0.6_7.tar.gz

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
    && gitrepodb add --basepath /data/python \
    && gitrepodb query --project java --head 10 \
    && gitrepodb add --basepath /data/java/ \
    && gitrepodb query --project jupyter --head 10 \
    && gitrepodb add --basepath /data/jupyter \
    && gitrepodb download --project python \
    && gitrepodb download --project java \
    && gitrepodb download --project jupyter \
    && cp repositories.db /results/ \
    && cd /src/javacodeseq \
    && ./gradlew run --args='--input /data/java --output /results/java.tsv' \
    && pycodeseq --input_path /data/python --output /results/python.tsv --method levels \
    && pycodeseq --input_path /data/jupyter --output /results/jupyter.tsv --method cells
