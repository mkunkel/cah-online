include .env
IMAGE_NAME := $(SERVICE_ID)

# Allow reusing the docker compose network for all containers
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))
DOCKER_COMPOSE_NETWORK := "$(shell echo $(CURRENT_DIR) | tr A-Z a-z)_default"

.PHONY: echo-image-name dev test build check mock clean

echo-image-name:
	@echo $(IMAGE_NAME)

dev: rm-containers
	docker-compose up

test:
	docker-compose run dev "./bin/test"

build:
	docker image build -t $(IMAGE_NAME) .

check:
	@$(MAKE) mock MOCK_DOCKER_ARGS='-d'
	./bin/check $(HOST_PORT)
	@$(MAKE) clean

mock: build
	@docker run $(MOCK_DOCKER_ARGS) --rm -it --network $(DOCKER_COMPOSE_NETWORK) --env-file ".env" -e RAILS_ENV=production -p $(HOST_PORT):$(CONTAINER_PORT) $(IMAGE_NAME)

clean: rm-containers rm-images

# ================================================================================
# Custom (helper) Make targets go below here
# ================================================================================

.PHONY: rm-containers rm-images

rm-containers:
	-@ docker container ls -aq -f "status=running" -f "label=service-id=$(SERVICE_ID)" | xargs -I {} docker container kill {}
	-@ docker container ls -aq -f "status=exited" -f "label=service-id=$(SERVICE_ID)" | xargs -I {} docker container rm {}

rm-images:
	-@ docker image ls -aq -f "dangling=true" -f "label=service-id=$(SERVICE_ID)" | xargs -I {} docker image rm -f {}
