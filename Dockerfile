FROM debian

ENV DST_INSTALL_DIR=/opt/dst
ENV STEAMCMD_DIR=/opt/steamcmd


ADD https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz /tmp/
COPY run-caves run-master start-server /usr/bin/

RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update && apt-get upgrade \
    && apt-get --yes install \
        lib32gcc1 \
        lib32stdc++6 \
        libgcc1 \
        libcurl4-gnutls-dev:i386 \
        unzip \
    && mkdir -p ${DST_INSTALL_DIR} ${STEAMCMD_DIR} \
    && tar xf /tmp/steamcmd_linux.tar.gz --directory ${STEAMCMD_DIR} \
    && rm /tmp/steamcmd_linux.tar.gz \
    && ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir "$DST_INSTALL_DIR" +login anonymous +app_update 343050 validate +quit

WORKDIR /opt/dst/
ENTRYPOINT [ "/bin/bash" ]
CMD [ "start-server" ]
