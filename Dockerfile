FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip curl  bash ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /v2ray

curl -fsSL "https://github.com/v2fly/v2ray-core/releases/download/v5.43.0/v2ray-linux-64.zip" -o /tmp/app.zip

COPY app.zip /tmp/app.zip
COPY run.sh /app/run.sh

RUN unzip -o /tmp/app.zip -d /app \
    && rm -f /tmp/app.zip \
    && chmod +x /app/run.sh

EXPOSE 3000

CMD ["/bin/bash", "/app/run.sh"]
