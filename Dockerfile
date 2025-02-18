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
COPY run.sh /usr/local/bin/run.sh

# Get repositories and Run analysis
ENTRYPOINT [ "/usr/local/bin/run.sh"]
CMD ["all"]