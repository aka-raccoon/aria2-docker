ARG VERSION
FROM docker.io/library/alpine:3.20

ENV ARIANG_VERSION=1.3.7 \
  CONF_DIR="/config" \
  UMASK="0002" \
  TZ="Etc/UTC" \
  RPC_SECRET="nothingfancy" \
  ARIA_SESSION_FILE="${CONF_DIR}/aria2.session"

USER root

RUN \
  apk add --no-cache aria2 caddy \
  && rm -rf \
    /root/.cache \
    /tmp/*

WORKDIR /usr/local/www/ariang
RUN wget --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip \
  -O ariang.zip  \
  && unzip ariang.zip \ 
  && rm ariang.zip \
  && chmod -R 755 ./

COPY Caddyfile /usr/local/caddy/
COPY aria2.conf ${CONF_DIR}/aria2.conf
COPY entrypoint.sh /aria2/entrypoint.sh

WORKDIR /aria2

VOLUME ${CONF_DIR}
VOLUME /data

EXPOSE 8080

RUN touch ${ARIA_SESSION_FILE} \
  && chown -R nobody:nogroup ${CONF_DIR}

USER nobody:nogroup

CMD [ "./entrypoint.sh" ]
