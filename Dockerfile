ARG UBI_NODE_VERSION
FROM registry.access.redhat.com/ubi8/nodejs-${UBI_NODE_VERSION}
# This image provides a Node.JS environment you can use to build your Modern Web Applications

EXPOSE 8080

ENV OUTPUT_DIR=build \
    NPM_RUN= \
    NPM_BUILD="npm run build" \
    DEPLOY_PORT=8080 \
    SUMMARY="Platform for building Modern Web Applications that use Node.js" \
    DESCRIPTION="Web Application building with Node.js"

LABEL io.k8s.description="$DESCRIPTION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858" \
      maintainer="Lucas Holmquist <lholmqui@redhat.com>" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      version="$NODE_VERSION" \
      name="nodeshift/ubi8-s2i-web-app"

COPY ./s2i/ $STI_SCRIPTS_PATH

USER 1001

# Set the default CMD to print the usage
CMD ${STI_SCRIPTS_PATH}/usage
