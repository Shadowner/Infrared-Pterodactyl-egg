FROM ghcr.io/parkervcp/yolks:debian

RUN apt-get update && apt-get install -y --no-install-recommends curl wget bash
RUN useradd -m -d /home/container container
RUN rm -rf /var/lib/apt/lists/*

USER container
ENV USER=container HOME=/home/container

COPY infrared /bin/infrared

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
