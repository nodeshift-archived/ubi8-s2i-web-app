# FROM openshift/base-centos7
FROM bucharestgold/centos7-s2i-nodejs
# This image provides a Node.JS environment you can use to run your
# Node.JS applications.

EXPOSE 8080

ENV NGINX_VERSION=1.6.3

ENV OUTPUT_DIR=build \
    DEBUG_PORT=5858 \
    NODE_VERSION=${NODE_VERSION} \
    NPM_VERSION=${NPM_VERSION} \
    SUMMARY="Platform for building and running Web Applications that use Node.js for building" \
    DESCRIPTION="Web Application building with Node.js and Serving with NGINX"

LABEL io.k8s.description="$DESCRIPTION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858" \
      maintainer="Lucas Holmquist <lholmqui@redhat.com>" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      version="$NODE_VERSION" \
      name="bucharestgold/centos7-s2i-web-app"

COPY ./s2i/ $STI_SCRIPTS_PATH
COPY ./contrib/ /opt/app-root

USER root

RUN /opt/app-root/etc/install_nginx.sh

USER 1001

# Set the default CMD to print the usage
CMD ${STI_SCRIPTS_PATH}/usage
