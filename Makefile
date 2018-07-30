.PHONY: default up stop restart down install

# Make sure the local file with docker-compose overrides exist.
$(shell ! test -e \.\/.docker\/docker-compose\.override\.yml && cat \.\/.docker\/docker-compose\.override\.default\.yml > \.\/.docker\/docker-compose\.override\.yml)

# Create a .env file if not exists and include default env variables.
$(shell ! test -e \.env && cat \.env.default > \.env)

# Make all variables from the file available here.
include .env

# Defines colors for echo, eg: @echo "${GREEN}Hello World${COLOR_END}". More colors: https://stackoverflow.com/a/43670199/3090657
YELLOW=\033[0;33m
RED=\033[0;31m
GREEN=\033[0;32m
COLOR_END=\033[0;37m

default: up

up:
	@echo "${YELLOW}Build and run containers...${COLOR_END}"
	docker-compose up -d  --remove-orphans
	@echo "${YELLOW}Streaming the project logs...${COLOR_END}"
	docker-compose logs -f node

stop:
	@echo "${YELLOW}Stopping containers...${COLOR_END}"
	docker-compose stop

restart:
	@echo "${YELLOW}Restarting containers...${COLOR_END}"
	$(MAKE) -s down
	$(MAKE) -s up

down:
	@echo "${YELLOW}Removing network & containers...${COLOR_END}"
	docker-compose down -v --remove-orphans

install:
	@echo "${YELLOW}Installing the project...${COLOR_END}"
	docker-compose run node sh -c "yarn install"

# https://stackoverflow.com/a/6273809/1826109
%:
	@: