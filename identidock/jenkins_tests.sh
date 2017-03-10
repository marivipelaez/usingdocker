#!/usr/bin/env bash

#Default compose args
COMPOSE_ARGS=" -f jenkins.yml -p jenkins "

#Make sure old containers are gone
sudo docker-compose $COMPOSE_ARGS stop
sudo docker-compose $COMPOSE_ARGS rm --force -v

#build the system
sudo docker-compose $COMPOSE_ARGS build --no-cache
sudo docker-compose $COMPOSE_ARGS up -d

#Run unit tests
sudo docker-compose $COMPOSE_ARGS run --no-deps --rm -e ENV=UNIT identidock
ERR=$?

#Run system test if unit tests passed
if [ $ERR -eq 0 ]; then
  IP=$(sudo docker inspect -f {{.NetworkSettings.IPAddress}} \
          jenkins_identidock_1)
  CODE=$(curl -sL -w "%{http_code}" $IP:9090/monster/bla -o /dev/null) || true
  if [ $CODE -ne 200 ]; then
    echo "Test passed - Tagging"
    HASH=$(git rev-parse --short HEAD)
    sudo docker tag -f jenkins_identidock vpelalo/identidock:$HASH
    sudo docker tag -f jenkins_identidock vpelalo/identidock:newest
    echo "Pushing"
    #sudo docker login -e <your-docker-email> -u <your-docker-id> -p <your-docker-pass>
    #sudo docker push amouat/identidock:$HASH 4
    #sudo docker push amouat/identidock:newest 4
  else
    echo "Site returned " $CODE
    ERR=1
  fi
fi

#Pull down the system
sudo docker-compose $COMPOSE_ARGS stop
sudo docker-compose $COMPOSE_ARGS rm --force -v

#Return err value to jenkins console
exit $ERR
