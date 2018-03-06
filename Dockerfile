FROM ubuntu:16.04
MAINTAINER Rob<rob@linkage.io>
LABEL Description "Mirror github Repos"

RUN apt-get -y update && apt-get install -y \
        curl \
        wget \
        git \
        gcc \
        build-essential \
        python3 

RUN apt-get install -y python3-pip 
RUN pip3 install setuptools flask pprint

RUN mkdir -p /src/ && \
    cd /src/ && \
    git clone https://github.com/LinkageIO/GitMirror.git && \
    cd GitMirror/ && \
    python3 setup.py install

WORKDIR /root

ENTRYPOINT ["gitmirror"]
