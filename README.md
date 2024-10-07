# Sonic Robo Blast 2 Kart Server

[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/rwanyoike/srb2kart-server-docker/docker-image.yml?branch=main)
](https://github.com/rwanyoike/srb2kart-server-docker/actions/workflows/docker-image.yml?query=branch%3Amain)
[![GitHub License](https://img.shields.io/github/license/rwanyoike/srb2kart-server-docker)
](LICENSE.txt)
[![Docker Image Version](https://img.shields.io/docker/v/rwanyoike/srb2kart-server)](https://hub.docker.com/r/rwanyoike/srb2kart-server)
[![Docker Image Size](https://img.shields.io/docker/image-size/rwanyoike/srb2kart-server)](https://hub.docker.com/r/rwanyoike/srb2kart-server)

> Containerized version of SRB2Kart.

<p align="center">
  <img src="assets/unknown.jpg" width="100%" alt="SRB2Kart">
</p>

Containerized version of [SRB2Kart](https://mb.srb2.org/showthread.php?t=43708), a kart racing mod based on the 3D Sonic the Hedgehog fangame [Sonic Robo Blast 2](https://srb2.org/), based on a modified version of [Doom Legacy](http://doomlegacy.sourceforge.net/). You can use SRB2Kart to run a SRB2Kart dedicated netgame server given the proper config.

## Usage

To start the SRB2Kart dedicated netgame server on port `5029/udp`:

```shell
docker run --name srb2kart-server -p 5029:5029/udp docker.io/rwanyoike/srb2kart-server:latest
```

### Data Directory

The `~/.srb2kart` directory is symlinked to `/data` in the container. You can mount a directory (with configuration files, mods, etc.) on your host machine to the `/data` directory inside the container.

> The container runs as the non-root user `1000:1000` (`id:group`, respectively). The the mounted directory must be writable by that user.

[For example](https://github.com/rwanyoike/gamersnights-srb2kart/tree/main/data), you can create a directory on your host machine with the necessary configuration files and mods, and then mount it to the container:

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

```shell
docker run --name srb2kart-server \
    -p 5029:5029/udp \
    -v ./host-srb2kart-data:/data \
    docker.io/rwanyoike/srb2kart-server:latest \
    -dedicated \
    -file \
    addons/kl_xxx.pk3 \
    addons/kl_xxx.wad \
    addons/kr_xxx.pk3
```

## Docker Build

The build will clone the [STJr/Kart-Public](https://github.com/STJr/Kart-Public) repository and build the SRB2Kart executable, as well as download the data files (`/usr/share/games/SRB2Kart`):

```shell
# Clone the repository
git clone https://github.com/rwanyoike/srb2kart-server-docker
# Navigate to the project directory
cd srb2kart-server-docker
# Build the game server
docker build -t srb2kart-server:<version> .
```
