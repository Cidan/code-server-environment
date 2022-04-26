FROM debian:10.8-slim

ENV USERNAME=code
ENV PUID=2000
ENV PGID=2000
ENV USERSHELL=/usr/bin/fish

RUN echo \
  'deb http://ftp.us.debian.org/debian/ buster main restricted universe multiverse \n\
   deb http://ftp.us.debian.org/debian/ buster-updates main restricted universe multiverse \n\
   deb http://ftp.us.debian.org/debian/ buster-backports main restricted universe multiverse \n\
  ' > /etc/apt/sources.list

# Install some basic packages + docker
RUN apt-get update && apt-get install -y \
   gcc g++ \
   apt-transport-https \
   ca-certificates \
   curl \
   gnupg-agent \
   wget \
   unzip \
   graphviz \
   lua5.3 \
   default-mysql-client \
   software-properties-common && \
   curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - &&\
   add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" && \
   echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' > /etc/apt/sources.list.d/shells:fish:release:3.list && \
   wget -nv https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key -O Release.key && \
   apt-key add - < Release.key && \
   curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
   echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
   apt-get update && apt-get install -y \
   docker-ce docker-ce-cli containerd.io fish python3-pip gnucobol redis-tools bazel && \
   rm -rf /var/cache/apt/archives/*


ARG ERLANG_VERSION=22.3-1
ARG ELIXIR_VERSION=1.10.2-1
ARG RUST_VERSION=1.50.0
ARG CODE_SERVER_VERSION=4.3.0

WORKDIR /tmp

# Install Code Server
RUN wget -q -O /tmp/code-server.tar.gz \
   https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-linux-amd64.tar.gz && \
   tar -xzf code-server.tar.gz && mv /tmp/code-server-${CODE_SERVER_VERSION}-linux-amd64 /usr/local/code-server && \
   rm /tmp/code-server.tar.gz && \
   chmod +x /usr/local/code-server/bin/code-server

# Setup sysctl limits
RUN  echo \
   'fs.inotify.max_user_watches=524288' >> /etc/sysctl.conf

# Setup our init
RUN echo \
   '#!/bin/bash \n\
   addgroup --quiet --gid ${PGID} ${USERNAME} \n\
   adduser --quiet --disabled-password --gecos "" --uid ${PUID} --gid ${PGID} --shell ${USERSHELL} ${USERNAME} \n\
   adduser --quiet ${USERNAME} docker \n\
   mkdir -p /home/${USERNAME}/.ssh \n\
   if [ ! -f /home/${USERNAME}/.ssh/id_rsa ]; then \n\
     ssh-keygen -b 4096 -t RSA -N "" -f /home/${USERNAME}/.ssh/id_rsa \n\
   fi \n\
   chown ${PUID}.${PGID} /home/${USERNAME} \n\
   su - ${USERNAME} -c "export export SERVICE_URL=https://marketplace.visualstudio.com/_apis/public/gallery && export ITEM_URL=https://marketplace.visualstudio.com/items && /usr/local/code-server/bin/code-server --disable-telemetry --disable-file-downloads --auth none --bind-addr 0.0.0.0:8472" \
   ' > /start.sh && chmod +x /start.sh

# Install Erlang
#RUN wget -q -O /tmp/erlang.deb \
#   https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_${ERLANG_VERSION}~debian~buster_amd64.deb && \
#   dpkg -i /tmp/erlang.deb || apt-get -y install -f && \
#   rm -rf /tmp/erlang.deb /var/cache/apt/archives/*

# Install Elixir
#RUN wget -q -O /tmp/elixir.deb \
#   https://packages.erlang-solutions.com/erlang/debian/pool/elixir_${ELIXIR_VERSION}~debian~buster_all.deb && \
#   dpkg -i /tmp/elixir.deb || apt-get -y install -f && \
#   rm -rf /tmp/elixir.deb /var/cache/apt/archives/*

# Install Rust
#RUN wget -q -O /tmp/rust.tar.gz \
#   https://static.rust-lang.org/dist/rust-${RUST_VERSION}-x86_64-unknown-linux-gnu.tar.gz && \
#   tar -xzf rust.tar.gz && \
#   mv rust-${RUST_VERSION}-x86_64-unknown-linux-gnu /usr/local/rust && \
#   ln -s /usr/local/rust/*/bin/* /usr/local/bin/ && \
#   rm /tmp/rust.tar.gz

# Install python3 libraries
RUN pip3 install --system \
   autopep8==1.5 \
   virtualenv==20.0.16

EXPOSE 8472 8081-8090
ENTRYPOINT [ "/start.sh" ]
