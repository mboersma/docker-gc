FROM gliderlabs/alpine:3.2

ENV DOCKER_VERSION 1.6.2

# We get curl so that we can avoid a separate ADD to fetch the Docker binary, and then we'll remove it
RUN apk --update add bash curl \
  && cd /tmp/ \
  && curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
  && tar zxf docker-${DOCKER_VERSION}.tgz \
  && mkdir -p /usr/local/bin/ \
  && mv $(find -name 'docker') /usr/local/bin/ \
  && chmod +x /usr/local/bin/docker \
  && apk del curl \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/*

COPY ./docker-gc /docker-gc

ADD crontab /var/spool/cron/crontabs/root

VOLUME /var/lib/docker-gc

CMD ["crond", "-f", "-l", "6", "-L", "/dev/stdout"]
