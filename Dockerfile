FROM alpine:3.19

RUN apk add --no-cache --update curl \
    && adduser --disabled-password --home /home/container container

USER container
ENV  USER=container HOME=/home/container

RUN curl -s https://api.github.com/repos/haveachin/infrared/releases/latest | grep "infrared_Linux_x86_64.tar.gz" | cut -d : -f 2,3 | tr -d \" | wget -qi -
RUN tar -xvf infrared_Linux_x86_64.tar.gz
RUN mv infrared /bin/infrared


WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]