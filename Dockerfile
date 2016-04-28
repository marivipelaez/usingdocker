FROM docker/whalesay:latest

RUN apt-get -y update

CMD cowsay "$@"
