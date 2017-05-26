FROM=openshift/base-centos7

# These values are changed in each version branch
# This is the only place they need to be changed
# other than the README.md file.
NODE_VERSION=7.10.0
NPM_VERSION=4.2.0
V8_VERSION=5.5.372.43
IMAGE_TAG=latest
LTS_TAG=

TARGET=bucharestgold/centos7-s2i-nodejs:$(IMAGE_TAG)

.PHONY: all
all: build squash test

.PHONY: build
build:
	docker build \
	--build-arg NODE_VERSION=$(NODE_VERSION) \
	--build-arg NPM_VERSION=$(NPM_VERSION) \
	--build-arg V8_VERSION=$(V8_VERSION) \
	-t $(TARGET) .

.PHONY: squash
squash: 
	docker-squash -f $(FROM) $(TARGET) -t $(TARGET)

.PHONY: test
test: build squash
	 BUILDER=$(TARGET) NODE_VERSION=$(NODE_VERSION) ./test/run.sh

.PHONY: clean
clean:
	docker rmi `docker images $(TARGET) -q`

.PHONY: tag
tag:
	if [ ! -z $(LTS_TAG) ]; then docker tag $(TARGET) $(IMAGE_NAME):$(LTS_TAG); fi

.PHONY: publish
publish: all
	docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)
	docker push $(TARGET)