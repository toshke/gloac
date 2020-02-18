## Development

Gloac uses [3 muskeeters](https://3musketeers.io/) as developer and ci interface to interact
with the code

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
make publish
```