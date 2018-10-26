# These values are changed in each version branch
# This is the only place they need to be changed
# other than the README.md file.
include versions.mk

FROM=nodeshift/centos7-s2i-nodejs:${BG_IMAGE_TAG}
IMAGE_NAME=nodeshift/centos7-s2i-web-app

TARGET=$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: all
all: build squash test

build: Dockerfile s2i
	docker build --build-arg BG_IMAGE_TAG=$(BG_IMAGE_TAG) -t $(TARGET) .

.PHONY: squash
squash:
	if [ -z $(SKIP_SQUASH) ] ; then docker-squash -f $(FROM) $(TARGET) -t $(TARGET); fi


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
