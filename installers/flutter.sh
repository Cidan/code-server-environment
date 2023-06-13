#!/bin/bash
set -e
export VERSION=3.10.4

rm -rf /home/${USER}/.apps/flutter
mkdir -p /home/${USER}/.apps
mkdir -p /home/${USER}/.local/bin

cd /tmp
wget -q -O /tmp/app.tar.xz \
  https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${VERSION}-stable.tar.xz

tar -xf app.tar.xz
mv flutter /home/${USER}/.apps/flutter
ln -fs /home/${USER}/.apps/flutter/bin/flutter /home/${USER}/.local/bin/
ln -fs /home/${USER}/.apps/flutter/bin/dart /home/${USER}/.local/bin/
rm -rf /tmp/app.tar.xz