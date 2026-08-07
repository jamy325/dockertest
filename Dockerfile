FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y unzip curl bash nginx ca-certificates \
    python3 python3-venv python3-pip \
    vim-tiny \
    net-tools iproute2 iputils-ping dnsutils \
    procps lsof less \
    screen ffmpeg \
    && rm -rf /var/lib/apt/lists/*

 RUN python3 -m venv /opt/venv \
  && /opt/venv/bin/python -m pip install -U pip \
  && /opt/venv/bin/python -m pip install --no-cache-dir telethon tgeraser

WORKDIR /v2ray

RUN curl -fsSL "https://github.com/v2fly/v2ray-core/releases/download/v5.52.0/v2ray-linux-64.zip" -o /tmp/app.zip

COPY run.sh /app/run.sh

RUN unzip -o /tmp/app.zip -d /app \
    && rm -f /tmp/app.zip \
    && chmod +x /app/run.sh

COPY config.json /app/config.json
COPY index.html /app/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["/bin/bash", "/app/run.sh"]
