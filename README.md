# proteansec/packetbeat

- [Introduction](#introduction)
- [Contributing](#contributing)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration Parameters](#configuration-parameters)

# Introduction

Dockerfile to build a [Packetbeat](https://www.elastic.co/products/beats/packetbeat) container image.

# Contributing

If you find this image useful you can help by doing one of the following:

- *Send a Pull Request*: you can add new features to the docker image, which will be integrated into the official image.
- *Report a Bug*: if you notice a bug, please issue a bug report at [Issues](https://github.com/proteansec/packetbeat/issues), so we can fix it as soon as possible.

# Prerequisites

**Host Network**

You need to give your image access to the host network by providing --net=host option to Docker.

**Elasticsearch**

Prior to using this image, you should already have an instance of Elasticsearch running, which is accessible by Docker from where you intend to run this image.

# Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/proteansec/packetbeat) and is the recommended method of installation.

```bash
docker pull proteansec/packetbeat:latest
```

Alternatively you can build the image locally.

```bash
git clone https://github.com/proteansec/packetbeat.git
cd packetbeat
docker build -t proteansec/packetbeat .
```

# Quick Start

We have to give packetbeat container access to the host network interface by specifying the **--net=host** parameter to be able to sniff the packets from it.

When running packetbeat container on the same host as elasticsearch, we can run it with the following command, since the container connects to Elasticsearch on **localhost:9200** by default.

```bash
docker run --name packetbeat -d --net=host -d proteansec/packetbeat app:start
```

When running packetbeat container on a different host as elasticsearch, we have to run it with appropriate environment variables:

```bash
docker run --name packetbeat -d --net=host --env 'ELASTICHOSTS="\"host:920\""' -d proteansec/packetbeat app:start
```

Now you should have the Packetbeat running, which will sniff the traffic from chosen network interface and send it to Elasticsearch.

# Configuration Parameters

*Refer to the documentation for the --env-file flag, which allows you to specify all environmental variables in a single file, which saves you from using overly complicated docker run commands.*

Below is the complete list of available options that can be used to customize your packetbeat container instance.

- **INTERFACE**: The interface where to sniff for packets (default: docker0).
- **PORTSDNS**: DNS ports (default: 53).
- **PORTSHTTP**: HTTP ports (default: 80, 8080, 8000, 5000, 8002).
- **PORTSMEMCACHE**: Memcache ports (default: 11211).
- **PORTSMYSQL**: Mysql ports (default: 3306).
- **PORTSPGSQL**: Postgresql ports (default: 5432).
- **PORTSREDIS**: Redis ports (default: 6379).
- **PORTSTHRIFT**: Thrift ports (default: 9090).
- **PORTSMONGODB**: MongoDB ports (default: 27017).
- **ELASTICENABLED**: Set this to `true` to enable saving the traffic information to elasticsearch (default: true).
- **ELASTICHOSTS**: Elasticsearch hosts where the data will be saved.
- **LOGSTASHENABLED**: Set this to `true` to enable saving the traffic information to logstash (default: false).
- **LOGSTASHHOSTS**: Logstash hosts where the data will be saved.
- **FILEENABLED**: Set this to `true` to enable saving the traffic information to a file (default: false).
- **FILEPATH**: The file where the traffic will be saved.
- **GEOIPPATH**: The path to the GeoIP database, which is already present in the container (default: /usr/local/share/GeoIP/GeoIP.dat).


