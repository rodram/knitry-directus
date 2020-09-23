SHELL=bash

version=v9.0.0-beta.1
tag=$(version)
cmd=
user=directus
registry=ghcr.io
repository=directus/next

.PHONY: build

action:
	act release \
		--actor $(user) \
		--secret-file .secrets

build-image:
	docker build \
		--build-arg VERSION=$(version) \
		--build-arg REPOSITORY=$(repository) \
		-t directus:temp \
		-f ./.github/actions/build-images/rootfs/directus/images/main/Dockerfile \
		./.github/actions/build-images/rootfs/directus/images/main

	docker tag directus:temp $(registry)/$(repository):$(version)
	docker tag directus:temp $(registry)/$(repository):$(tag)
	docker image rm directus:temp

run-image:
	docker run --rm -it $(registry)/$(repository):$(tag) $(cmd)
