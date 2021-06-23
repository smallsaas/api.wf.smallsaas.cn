#!/bin/sh
COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILD=1 docker-compose build --no-cache --force-rm

docker-compose up --detach --remove-orphans
