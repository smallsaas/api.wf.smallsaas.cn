#!/bin/sh

COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILD=1 docker-compose up --build --detach --remove-orphans
