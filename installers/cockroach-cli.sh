#!/bin/bash
export COCKROACH_VERSION=22.1.0

rm -rf /home/${USER}/.apps/cdb
mkdir -p /home/${USER}/.apps
mkdir -p /home/${USER}/.local/bin
cd /tmp

wget -q -O /tmp/cdb.tgz \
  https://binaries.cockroachdb.com/cockroach-v${COCKROACH_VERSION}.linux-amd64.tgz && \
  tar -xzf /tmp/cdb.tgz && \
  mv cockroach-v${COCKROACH_VERSION}.linux-amd64 /home/${USER}/.apps/cdb && \
  ln -fs /home/${USER}/.apps/cdb/cockroach /home/${USER}/.local/bin/cockroach && \
  rm -rf /tmp/cdb.tgz