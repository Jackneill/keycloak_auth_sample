SHELL := /usr/bin/env bash

DOCKER ?= podman

export DOCKER_BUILDKIT=1

IMAGE_NAME ?= keycloak_custom
TMP ?= .tmp

.PHONY: all
all:
	# no-op

.PHONY: build
build:

.PHONY: run-keycloak-dev
run-keycloak-dev:
	$(DOCKER) run --rm $(IMAGE_NAME)

.PHONY: gen-dev-keycloak-certs
gen-dev-keycloak-certs:
	mkdir -p ${TMP}
	$(DOCKER) run --rm $(IMAGE_NAME) \
		-w /opt/keycloak \
		-c "keytool \
			-genkeypair \
			-storepass password \
			-storetype PKCS12 \
			-keyalg RSA \
			-keysize 2048 \
			-dname "CN=server" \
			-alias server \
			-ext "SAN:c=DNS:localhost,IP:127.0.0.1" \
			-keystore conf/server.keystore"

.PHONY: docker-image
docker-image:
	$(DOCKER) build -t $(IMAGE_NAME) .

.PHONY: clean
clean:
	rm -rf ${TMP}
