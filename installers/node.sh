#!/bin/bash
export VERSION=12.18.3

rm -rf /home/${USER}/.apps/node
mkdir -p /home/${USER}/.apps
mkdir -p /home/${USER}/.local/bin

cd /tmp
wget -q -O /tmp/app.tar.gz \
   https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-x64.tar.gz && \
   tar -xzf app.tar.gz && mv node-v${VERSION}-linux-x64 /home/${USER}/.apps/node && \
   ln -fs /home/${USER}/.apps/node/bin/* /home/${USER}/.local/bin/ && \
   rm -rf /tmp/app.tar.gz
