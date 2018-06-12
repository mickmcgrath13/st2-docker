# Step by step instructions

## Install

We use Version 3 of the compose file format, so if you want to run docker-compose, you'll need to
ensure you're running Docker Engine release 1.13.0+.

First, execute

  ```
  make init
  ```

to create the environment files used by `docker-compose`. You may want to change the values of the
variables as necessary, but the defaults should be okay if you are not using any off-cluster
services (e.g. mongo, redis, postgres, rabbitmq).

NOTE: `make init` only needs to be run once.

As an example, if you want to change the username and password used by StackStorm, change the
`ST2_USER` and `ST2_PASSWORD` variables in `conf/stackstorm.env` prior to bringing up your docker
environment.

Second, start the docker environment. execute

  ```
  docker-compose up -d
  ```

This will pull the required images from docker hub, and then start them.

To stop the docker environment, run:

  ```
  docker-compose down
  ```

## Building the stackstorm image

The pre-built `stackstorm/stackstorm` image may not meet your requirements. You may need to install
additional libraries, packages or files into the image. For example, if you want to install the
Ansible pack, you must first install the `libkrb5-dev` package. While the package could be installed
using a script in `/st2-docker/entrypoint.d`, this will increase the startup time of the container
and may result in containers that execute different code than others.

Make any necessary changes to `images/stackstorm/Dockerfile`. For example, append `libkrb5-dev` to
the first `apt-get install` command. Next, run:

  ```
  REPO=stable
  docker build --build-arg ST2_REPO=${REPO} -t stackstorm/stackstorm:${REPO} images/stackstorm
  ```

where REPO is one of 'stable', 'unstable', 'staging-stable', 'staging-unstable'.  Otherwise,
the following `docker-compose` command will download the specified image from docker hub.


### Getting started: Simple Tutorial Tour

After you spin up the environment, you can play around with st2 *in container-ized environment* by following [this tutorial guide](./docs/tutorial.md).


## Data persistence

It's designed to suffice the ordinary use case by default. If you need to customize it, check below and modify `docker-compose.yml`

- The mongo, rabbitmq, postgres and redis containers store their data on persistent storage
- The stackstorm container persists the contents in following directories
    - `/var/log`
    - `/opt/stackstorm/packs`
    - `/opt/stackstorm/virtualenvs`
    - `/opt/stackstorm/configs`

Since data directories may persist between invocations of `docker-compose`, you may see the following error:

```
2018-02-21 16:36:21.453 UTC [1] FATAL:  database files are incompatible with server
2018-02-21 16:36:21.453 UTC [1] DETAIL:  The data directory was initialized by PostgreSQL version 9.6, which is not compatible with this version 10.2 (Debian 10.2-1.pgdg90+1).
```

In `docker-compose.yml`, pin the postgres version to `9.6` and you will not see the error again.

```
-    image: postgres:latest
+    image: postgres:9.6
```

## Environment variables

Below is the complete list of available options that can be used to customize your container.

| Parameter | Description |
|-----------|-------------|
| `ST2_USER`     | StackStorm account username |
| `ST2_PASSWORD` | StackStorm account password |
| `MONGO_HOST` | MongoDB server hostname |
| `MONGO_PORT` | MongoDB server port (typically `27017`) |
| `MONGO_DB`   | *(Optional)* MongoDB dbname (will use `st2` if not specified) |
| `MONGO_USER` | *(Optional)* MongoDB username (will connect without credentials if this and `MONGO_PASS` are not specified) |
| `MONGO_PASS` | *(Optional)* MongoDB password |
| `RABBITMQ_HOST`         | RabbitMQ server hostname |
| `RABBITMQ_PORT`         | RabbitMQ server port (typically `5672`) |
| `RABBITMQ_DEFAULT_USER` | RabbitMQ username |
| `RABBITMQ_DEFAULT_PASS` | RabbitMQ password |
| `POSTGRES_HOST`     | PostgreSQL server hostname |
| `POSTGRES_PORT`     | PostgreSQL server port (typically `5432`) |
| `POSTGRES_DB`       | PostgreSQL database |
| `POSTGRES_USER`     | PostgreSQL username |
| `POSTGRES_PASSWORD` | PostgreSQL password |
| `REDIS_HOST`     | Redis server hostname |
| `REDIS_PORT`     | Redis server port |
| `REDIS_PASSWORD` | *(Optional)* Redis password |


## Running custom shell scripts on boot

The `stackstorm` container supports running arbitrary shell scripts when the container launches:

* Scripts located in `/st2-docker/entrypoint.d` are executed before the init process starts any
stackstorm services.
* Scripts located in `/st2-docker/st2.d` are executed after stackstorm services are running.

NOTE: Only scripts with a suffix of `.sh` will be executed, and in alphabetical order of the file
name.

### /st2-docker/entrypoint.d

For example, if you want to modify `/etc/st2/st2.conf` to set `system_packs_base_path` parameter,
create `modify-st2-config.sh` with the follwing content:

  ```
  #/bin/bash
  crudini --set /etc/st2/st2.conf content system_packs_base_path /opt/stackstorm/custom_packs
  ```

Then bind mount it to `/st2-docker/entrypoint.d/modify-st2-config.sh`

- via `docker run`

  ```
  docker run -it -d --privileged \
    -v /path/to/modify-st2-config.sh:/st2-docker/entrypoint.d/modify-st2-config.sh \
    stackstorm/stackstorm:latest
  ```

- via `docker-compose.yml`

  ```
  services:
    stackstorm:
      image: stackstorm/stackstorm:${TAG:-latest}
       : (snip)
      volumes:
        - /path/to/modify-st2-config.sh:/st2-docker/entrypoint.d/modify-st2-config.sh
  ```

The above example shows just modifying st2 config but basically there is no limitation so you can
do almost anything.

You can also bind mount a specific directory to `/st2-docker/entrypoint.d` then place scripts as
much as you want.

### /st2-docker/st2.d

Scripts in this directory can be used to register packs, reload or restart services, etc.
You can bind mount these scripts as mentioned in the previous section.

NOTE: These scripts are currently not available when running in 1ppc mode.


## To enable chatops

Chatops is installed in the `stackstorm` image, but not started by default.

To enable chatops, delete the file `/etc/init/st2chatops.override` using a script in
`/st2-docker/entrypoint.d`.

  ```
  #!/bin/bash

  sudo rm /etc/init/st2chatops.override
  ```

You also need to configure it either

- by passing all required parameters for st2chatops to the stackstorm container via environment variables
- by replacing `/opt/stackstorm/chatops/st2chatops.env` with the one that is properly configured. The easiest way is to use bind-mount.

## packs.dev directory

By default, `./packs.dev` directory is bind-mounted to `/opt/stackstorm/packs.dev` in `stackstorm` container and registered as a secondary pack location. This is done by the startup script at [./runtime/entrypoint.d/add-packs-dev.sh](./runtime/entrypoint.d/add-packs-dev.sh)

This feature exists just for convenience, for testing and developing packs, and for [tutorial](./docs/tutorial.md). You can use it for arbitrary purpose, or ignore, or even disable it completely by removing corresponding entries and files.
Refer to the official StackStorm document for the list of available configuration parameters for `st2chatops`.

## Advanced: using 1ppc image

Official image now supports running in 1ppc mode: stands for *One Process Per Container*. Interested? Check [runtime/compose-1ppc](./runtime/compose-1ppc)
