#!/bin/bash
export VERSION=14

rm -rf /home/${USER}/.apps/java
mkdir -p /home/${USER}/.apps
mkdir -p /home/${USER}/.local/bin

cd /tmp

wget -q -O /tmp/app.tar.gz \
   https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-${VERSION}_linux-x64_bin.tar.gz && \
   tar -xzf app.tar.gz && mv /tmp/jdk-${VERSION} /home/${USER}/.apps/java && \
   ln -fs /home/${USER}/.apps/java/bin/* /home/${USER}/.local/bin/ && \
   rm /tmp/app.tar.gz
