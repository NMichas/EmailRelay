#Modified from https://github.com/drdaeman/docker-emailrelay
FROM alpine:3.10.2

RUN apk add --no-cache libstdc++ openssl ca-certificates \
 && update-ca-certificates

ARG VERSION=2.0.1

RUN apk add --no-cache --virtual .deps curl g++ make autoconf automake openssl-dev \
 && mkdir -p /tmp/build && cd /tmp/build \
 && curl -o emailrelay.tar.gz -L "https://downloads.sourceforge.net/project/emailrelay/emailrelay/${VERSION}/emailrelay-${VERSION}-src.tar.gz" \
 && tar xzf emailrelay.tar.gz \
 && cd emailrelay-${VERSION} \
 && ./configure --prefix=/usr --with-openssl \
 && make \
 && make install \
 && apk --no-cache del .deps \
 && cd / \
 && rm -rf /tmp/build /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* \
 && mkdir -p /var/spool/emailrelay

 CMD emailrelay --help --verbose