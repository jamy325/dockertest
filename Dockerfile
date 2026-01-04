FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip bash ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /v2ray

COPY app.zip /tmp/app.zip
COPY run.sh /app/run.sh

RUN unzip -o /tmp/app.zip -d /app \
    && rm -f /tmp/app.zip \
    && chmod +x /app/run.sh

EXPOSE 1080

CMD ["/bin/bash", "/app/run.sh"]
