# These values are changed in each version branch
# This is the only place they need to be changed
# other than the README.md file.
include versions.mk

IMAGE_NAME=nodeshift/ubi8-s2i-web-app

TARGET=$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: all
all: build test

build: Dockerfile s2i
	docker build --build-arg UBI_NODE_VERSION=$(UBI_NODE_VERSION) --pull -t $(TARGET) .

.PHONY: test
test: build
	 BUILDER=$(TARGET) NODE_VERSION=$(NODE_VERSION) ./test/run.sh

.PHONY: clean
clean:
	docker rmi `docker images $(TARGET) -q`

.PHONY: tag
tag:
	if [ ! -z $(LTS_TAG) ]; then docker tag $(TARGET) $(IMAGE_NAME):$(LTS_TAG); fi
	docker tag $(TARGET) $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: publish
publish: all
	echo $(DOCKER_PASS) | docker login -u $(DOCKER_USER) --password-stdin
	docker push $(TARGET)
	if [ ! -z $(LTS_TAG) ]; then docker push $(IMAGE_NAME):$(LTS_TAG); fi
