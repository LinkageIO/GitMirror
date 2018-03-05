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

RUN mkdir -p /src/ && \
    cd /src/ && \
    git clone https://github.com/LinkageIO/GitMirror.git && \
    cd GitMirror/ && \
    python setup.py install

WORKDIR /root

ENTRYPOINT ["/bin/bash"]
