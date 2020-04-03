FROM debian:10.3-slim

ENV USERNAME=code
ENV PUID=2000
ENV PGID=2000

### Note: Language versions defined a bit below, so we don't have
### to regenerate this first run step.

# Install some basic packages + docker
RUN apt-get update && apt-get install -y \
gcc g++ \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
wget \
software-properties-common && \
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - &&\
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" && \
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' > /etc/apt/sources.list.d/shells:fish:release:3.list && \
wget -nv https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key -O Release.key && \
apt-key add - < Release.key && \
apt-get update && apt-get install -y \
docker-ce docker-ce-cli containerd.io fish python3-pip && \
rm -rf /var/cache/apt/archives/*

### Define your language versions here, or pass them in to build
### with --build-arg

ARG NODE_VERSION=12.16.1
ARG GO_VERSION=1.14.1
ARG CODE_SERVER_VERSION=3.0.2

WORKDIR /tmp

# Install node
RUN wget -O /tmp/node.tar.gz \
https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz && \
tar -xvzf node.tar.gz && mv node-v${NODE_VERSION}-linux-x64 /usr/local/node && \
ln -s /usr/local/node/bin/node /usr/local/bin/node && \
ln -s /usr/local/node/bin/npm /usr/local/bin/npm && \
rm -rf /tmp/node.tar.gz

# Install Go
RUN wget -O /tmp/go.tar.gz \
https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
tar -xvzf go.tar.gz && mv go /usr/local/go && \
ln -s /usr/local/go/bin/go /usr/local/bin/go && \
rm -rf /tmp/go.tar.gz

# Install Code Server
RUN wget -O /tmp/code-server.tar.gz \
https://github.com/cdr/code-server/releases/download/${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-linux-x86_64.tar.gz && \
tar -xvzf code-server.tar.gz && mv /tmp/code-server-${CODE_SERVER_VERSION}-linux-x86_64 /usr/local/code-server && \
rm /usr/local/code-server/node /tmp/code-server.tar.gz && echo \
'#!/bin/bash \n\
/usr/local/bin/node /usr/local/code-server/out/node/entry.js $@' > /usr/local/bin/code-server && \
chmod +x /usr/local/bin/code-server

# Setup our init
RUN echo \
'#!/bin/bash \n\
addgroup --quiet --gid ${PGID} ${USERNAME} \n\
adduser --quiet --disabled-password --gecos "" --uid ${PUID} --gid ${PGID} --shell /usr/bin/fish ${USERNAME} \n\
adduser --quiet ${USERNAME} docker \n\
su - ${USERNAME} -c "/usr/local/bin/code-server --disable-telemetry --disable-ssh --auth none --host 0.0.0.0" \
' > /start.sh && chmod +x /start.sh

EXPOSE 8080
ENTRYPOINT [ "/start.sh" ]