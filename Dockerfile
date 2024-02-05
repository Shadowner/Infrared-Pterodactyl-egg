FROM alpine:3.19

RUN apk add --no-cache --update curl wget\
    && adduser --disabled-password --home /home/container container

USER container
ENV  USER=container HOME=/home/container

COPY infrared /bin/infrared

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]