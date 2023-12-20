#!/bin/bash
export GCLOUD_VERSION=457.0.0
rm -rf /home/${USER}/.apps/gcloud
mkdir -p /home/${USER}/.local/bin
mkdir -p /home/${USER}/.apps
cd /tmp

wget -q -O /tmp/gcloud.tar.gz \
   https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz && \
   tar -xzf gcloud.tar.gz && \
   mv google-cloud-sdk /home/${USER}/.apps/gcloud && \
   /home/${USER}/.apps/gcloud/bin/gcloud -q components list --format "csv(id)" | grep -v '^id$' | xargs /home/${USER}/.apps/gcloud/bin/gcloud components install && \
   rm /tmp/gcloud.tar.gz && \
   find /home/${USER}/.apps/gcloud/bin -maxdepth 1 \( ! -name '*\.*' \) -type f -exec ln -fs {} /home/${USER}/.local/bin/ ';'
