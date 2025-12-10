FROM python:3.13-slim-trixie

ENV TZ=Asia/Baghdad
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && \
    apt install -y --no-install-recommends mariadb-client s3cmd && \
    pip3.13 install yacron && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY backup.sh /usr/local/bin/backup
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint


RUN chmod +x /usr/local/bin/backup
RUN chmod +x /usr/local/bin/docker-entrypoint

WORKDIR /root

ENTRYPOINT ["docker-entrypoint"]

