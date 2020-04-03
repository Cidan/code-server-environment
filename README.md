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
docker run --name code-server --hostname code -e USERNAME=${USER} -e PUID=$(id -u) -e PGIG=$(id -g) -p 8080:8080 -v $HOME/code-server:/code-server -v /var/run/docker.sock:/var/run/docker.sock -d -t code-server-container
```

Then point your browser to `http://localhost:8080` and you're all set!

## Language Support

As of right now, the following languages are supported:

* C
* C++
* NodeJS
* Go

Language versions can be set at build time via the `--build-arg` docker argument. For example:

```bash
docker build -t code-server-container --build-arg GO_VERSION=1.13.0
```