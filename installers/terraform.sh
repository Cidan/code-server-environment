#!/bin/bash
export VERSION=1.2.1
mkdir -p /home/${USER}/.local/bin
mkdir -p /home/${USER}/.apps
cd /tmp

wget -q -O /tmp/app.zip \
   https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip && \
   unzip app.zip && \
   mv terraform /home/${USER}/.local/bin/ && \
   rm /tmp/app.zip
