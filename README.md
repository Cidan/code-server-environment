# Code Server Container

A fully integrated [code server](https://github.com/cdr/code-server) container.

## Why?

Code server is an incredibly useful project for running and managing a full VS Code IDE with no client to install other than a web browser. The entire IDE runs remotely, however in order for language completion, compiling, and tests to work, languages must be installed and managed remotely as well. This container aims to solve three things:

* Setting up code-server
* Setting up installs for the most popular languages
* Setting up persistant volumes for VSCode settings and code storage

## Usage

Simply build this container like so:

```bash
docker build -t code-server-container .
```

and then run it:

```bash
docker run --name code-server --hostname code -e USERNAME=${USER} \
-e PUID=$(id -u) -e PGID=$(id -g) -p 8080:8080 -v $HOME:/home/${USER} \ 
-v /var/run/docker.sock:/var/run/docker.sock -d -t code-server-container
```

Then point your browser to `http://localhost:8080` and you're all set!

## Options
If you are running this container on your local machine, your home directory (or any other directory your user owns) should be mounted to `/home/${USER}`. `${USER}` *must be the same as the `USERNAME` variable below.*

If you are running this container on Kubernetes, you will want to mount a PVC to `/home/${USER}` so that settings, code checkouts, etc, follow the end user when the container migrates hosts.

The following environmental variables can be set at run time to configure the container. The values below are the default values.

```bash
# The username to launch under. Mostly cosmetic as it sets the /home/${USERNAME} path.
USERNAME=code
# The UID to launch as. This must be the same UID that owns the directory you will mount to /home/${USER}.
PUID=2000
# The primary GID for the UID above.
PGID=2000
# The shell to use when launching. This will affect the shell used for the built in terminal in VSCode. Change this to /bin/bash for standard bash.
USERSHELL=/usr/bin/fish
```
## Language Support

As of right now, the following languages are supported:

* C
* C++
* Java 14
* NodeJS 12
* Go 1.14
* Python 3.7
* Rust 1.42.0 
* Erlang 22.3
* Elixir 1.10

Language versions can be set at build time via the `--build-arg` docker argument. For example:

```bash
docker build -t code-server-container --build-arg GO_VERSION=1.13.0
```

## FAQ

### What do I do if I need to run a dev site that requires an open port?
Port 8080 is reserved for VSCode, but ports 8081-8090 are exposed in the default Dockerfile as well. Use one of these ports as your port for your dev site and bind it to a host port. 

### Why is fish shell the default shell?
Because it's the shell I use, :)