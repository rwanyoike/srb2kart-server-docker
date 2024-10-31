FROM docker.io/library/alpine:3.20

ARG SRB2KART_REPO=https://github.com/STJr/Kart-Public
ARG SRB2KART_VERSION=v1.6
ARG SRB2KART_USER=srb2kart

# Ref: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=srb2kart-data
RUN set -ex \
    && apk add --no-cache -t .build-deps curl \
    && _assets=/tmp/srb2kart-data_${SRB2KART_VERSION}.zip \
    && _target=/usr/share/games/SRB2Kart \
    && curl -fL -o ${_assets} ${SRB2KART_REPO}/releases/download/${SRB2KART_VERSION}/AssetsLinuxOnly.zip \
    && mkdir -p ${_target} \
    && unzip -d ${_target} ${_assets} \
    && find ${_target}/mdls -type d -print -exec chmod 0755 {} \; \
    && rm ${_assets} \
    && apk del .build-deps

# Ref: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=srb2kart
RUN set -ex \
    && apk add --no-cache -t .build-deps \
        bash \
        build-base \
        curl-dev \
        git \
        libgme-dev \
        libpng-dev \
        sdl2_mixer-dev \
        sdl2-dev \
    && _target=/tmp/srb2kart_${SRB2KART_VERSION} \
    && git clone --depth=1 -b ${SRB2KART_VERSION} ${SRB2KART_REPO} ${_target} \
    && cd ${_target}/src \
    # Ref: https://wiki.srb2.org/wiki/Source_code_compiling
    # NOUPX - Don't compress with UPX (speed up compiling)
    # NOOBJDUMP - Don't dump symbols (speed up compiling)
    # LINUX64 - Compile for x86_64 Linux
    # NOHW - Disable OpenGL and OpenAL
    && make -j$(nproc) NOUPX=1 NOOBJDUMP=1 LINUX64=1 NOHW=1 \
    && cp ${_target}/bin/Linux64/Release/lsdl2srb2kart /usr/bin/srb2kart \
    && rm -r ${_target} \
    && apk del .build-deps

RUN set -ex \
    && apk add --no-cache \
        libcurl \
        libgme \
        libpng \
        sdl2 \
        sdl2_mixer

RUN adduser -D ${SRB2KART_USER} \
    && mkdir /data \
    && chown ${SRB2KART_USER}:${SRB2KART_USER} /data \
    && ln -s /data /home/${SRB2KART_USER}/.srb2kart

USER ${SRB2KART_USER}

WORKDIR /data

EXPOSE 5029/udp

STOPSIGNAL SIGINT

CMD ["srb2kart", "-dedicated"]
