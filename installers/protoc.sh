#!/bin/bash

export VERSION=3.13.0

rm -rf /home/${USER}/.local/include/google
mkdir -p /home/${USER}/.apps
mkdir -p /home/${USER}/.local/bin
mkdir -p /home/${USER}/.local/include

cd /tmp

wget -q -O /tmp/app.zip \
   https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION}/protoc-${VERSION}-linux-x86_64.zip && \
   unzip app.zip && \
   mv bin/protoc /home/${USER}/.local/bin/ && \
   mv include/* /home/${USER}/.local/include/ && \
   rm -rf /tmp/bin /tmp/include /tmp/app.zip /tmp/readme.txt
