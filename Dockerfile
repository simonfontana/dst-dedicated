FROM debian

ENV DST_INSTALL_DIR=/opt/dst
ENV DST_CONF_DIR=/root/.klei/DoNotStarveTogether
ENV STEAMCMD_DIR=/opt/steamcmd


ADD https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz /tmp/
COPY MyDediServer.zip /tmp/
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
    && mkdir -p ${DST_INSTALL_DIR} ${DST_CONF_DIR} ${STEAMCMD_DIR} \
    && tar xf /tmp/steamcmd_linux.tar.gz --directory ${STEAMCMD_DIR} \
    && unzip /tmp/MyDediServer.zip -d ${DST_CONF_DIR} \
    && rm /tmp/steamcmd_linux.tar.gz /tmp/MyDediServer.zip \
    && ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir "$DST_INSTALL_DIR" +login anonymous +app_update 343050 validate +quit

WORKDIR /opt/dst/
ENTRYPOINT [ "/bin/bash" ]
CMD ["start-server"]
