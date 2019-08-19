######################################################################################################################################################

# @project        Libraries
# @file           Makefile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

######################################################################################################################################################

export project_name := library-base
export project_version := 0.1.8
export project_directory := $(shell git rev-parse --show-toplevel)

export docker_registry_path := openspacecollective
export docker_image_repository := $(docker_registry_path)/$(project_name)
export docker_image_version := $(project_version)

######################################################################################################################################################

build-images: build-image-debian build-image-fedora

build-image-debian: linux := debian
build-image-fedora: linux := fedora

build-image-debian build-image-fedora: _build_image

_build_image:

	docker build \
	--file="$(project_directory)/docker/$(linux)/Dockerfile" \
	--tag=$(docker_image_repository):$(docker_image_version)-$(linux) \
	--tag=$(docker_image_repository):latest-$(linux) \
	--build-arg="VERSION=$(docker_image_version)" \
	"$(project_directory)/docker/$(linux)"

######################################################################################################################################################

run-image-debian: linux := debian
run-image-fedora: linux := fedora

run-image-debian run-image-fedora: _run-image

_run-image: _build_image

	docker run \
	-it \
	--rm \
	$(docker_image_repository):$(docker_image_version)-$(linux) \
	/bin/bash

######################################################################################################################################################

deploy-images: deploy-image-debian deploy-image-debian

deploy-image-debian: linux := debian
deploy-image-fedora: linux := fedora

deploy-image-debian deploy-image-fedora: _deploy-image

_deploy-image: _build-image

	docker push $(docker_image_repository):$(docker_image_version)-$(linux)
	docker push $(docker_image_repository):latest-$(linux)

######################################################################################################################################################

.PHONY: build-images build-image-debian build-image-fedora \
		run-image-debian run-image-fedora \
		deploy-images deploy-image-debian deploy-image-fedora

######################################################################################################################################################
