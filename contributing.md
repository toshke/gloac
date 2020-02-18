## Development

Gloac uses [3 muskeeters](https://3musketeers.io/) as developer and ci interface to interact
with the code

Arguments to make can be passed either in environment variable format, or as an argument format, e.g.

```
make build GEM_VERSION=123
# is same is
GEM_VERSION=123 make build
```

#### Build gem

```shell
make build
```

#### Running tests

```shell
make test
```

#### Build and install gem locally

```shell
make clean build _local_install
```

#### Publish new version of the gem

```shell
make publish GEM_VERSION=0.0.1 
```

#### Build docker image

```shell
make buildDocker GEM_VERSION=0.0.1 DOCKER_TAG=0.0.1-alpine 
```