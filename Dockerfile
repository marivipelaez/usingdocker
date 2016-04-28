FROM docker/whalesay:latest

MAINTAINER Marivi Pelaez

RUN apt-get -y update && apt-get install -y fortunes

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

