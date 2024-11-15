# Sonic Robo Blast 2 Kart Server

[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/rwanyoike/srb2kart-server-docker/docker-image.yml?branch=main)
](https://github.com/rwanyoike/srb2kart-server-docker/actions/workflows/docker-image.yml?query=branch%3Amain)
[![GitHub License](https://img.shields.io/github/license/rwanyoike/srb2kart-server-docker)
](LICENSE.txt)
[![Docker Image Version](https://img.shields.io/docker/v/rwanyoike/srb2kart-server)](https://hub.docker.com/r/rwanyoike/srb2kart-server)
[![Docker Image Size](https://img.shields.io/docker/image-size/rwanyoike/srb2kart-server)](https://hub.docker.com/r/rwanyoike/srb2kart-server)

> Containerized version of SRB2Kart.

![SRB2Kart](assets/unknown.jpg)

A containerized version of [SRB2Kart](https://mb.srb2.org/showthread.php?t=43708), a kart racing mod based on the 3D Sonic the Hedgehog fangame [Sonic Robo Blast 2](https://srb2.org/), which is based on a modified version of [Doom Legacy](http://doomlegacy.sourceforge.net/). You can use it to run a dedicated SRB2Kart netgame server.

## Usage

To start the SRB2Kart dedicated netgame server on port `5029/udp`, run:

```shell
docker run --name srb2kart-server -p 5029:5029/udp docker.io/rwanyoike/srb2kart-server:latest
```

### Data Directory

The `~/.srb2kart` directory is linked to `/data` inside the container. You can mount a directory from your host (containing configuration files, mods, etc.) to the `/data` directory in the container.

For example, create a directory on your host with the necessary files:

```shell
$ tree host-srb2kart-data/
host-srb2kart-data
├── addons
│   ├── kl_xxx.pk3
│   ├── kl_xxx.wad
│   └── kr_xxx.pk3
└── kartserv.cfg

1 directory, 4 files
```

> The container runs as a non-root user `1000:1000`. Ensure the mounted directory is writable by this user.

To run the server with your custom data, use:

```shell
docker run --name srb2kart-server \
    -p 5029:5029/udp \
    -v ./host-srb2kart-data:/data \
    docker.io/rwanyoike/srb2kart-server:latest \
    srb2kart \
    -dedicated \
    -file \
    addons/kl_xxx.pk3 \
    addons/kl_xxx.wad \
    addons/kr_xxx.pk3
```

## Build

To build the container, follow these steps:

```shell
# Clone the repository
git clone https://github.com/rwanyoike/srb2kart-server-docker
# Navigate to the project directory
cd srb2kart-server-docker
# Build the container
docker build -t srb2kart-server:<version> .
```
