#!/bin/bash
export VERSION=1.19.4

rm -rf /home/${USER}/.apps/go
mkdir -p /home/${USER}/.apps
mkdir -p /home/${USER}/.local/bin

cd /tmp
wget -q -O /tmp/app.tar.gz \
   https://dl.google.com/go/go${VERSION}.linux-amd64.tar.gz && \
   tar -xzf app.tar.gz && mv go /home/${USER}/.apps/go && \
   ln -fs /home/${USER}/.apps/go/bin/* /home/${USER}/.local/bin/ && \
   rm -rf /tmp/app.tar.gz
