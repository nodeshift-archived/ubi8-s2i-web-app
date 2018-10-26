# OpenShift Builder Images for Web Applications

[![Build Status](https://travis-ci.org/nodeshift/centos7-s2i-web-app.svg?branch=master)](https://travis-ci.org/nodeshift/centos7-s2i-web-app)

## Usage

Using this image with OpenShift `oc` command line tool, or with `s2i` directly, will
assemble your application source with its required dependencies, creating a new
container image. This image contains your built Modern Web Application.

The built files will be located in `/opt/app-root/output`

### OpenShift

The [`oc` command-line tool](https://github.com/openshift/origin/releases) can be
used to start a build, layering your desired Web Application `REPO_URL` sources into a centos7
image with your selected `RELEASE` of Node.js via the following command format:

```
oc new-app nodeshift/centos7-s2i-web-app:latest~https://github.com/lholmquist/react-web-app
```

### Docker

The [Source2Image cli tools](https://github.com/openshift/source-to-image/releases)
are available as a standalone project, allowing you to run your application directly
in Docker.

This example will produce a new Docker image named `webapp`:

```
s2i build https://github.com/nodeshift/centos7-s2i-web-app --context-dir=test/test-react-app/ nodeshift/centos7-s2i-web-app:latest webapp
```

Then you can run the application image like this.

```
docker run -p 8080:8080 --rm -it webapp
```

## Configuration

Use the following environment variables to configure the runtime behavior of the
application image created from this builder image.

NAME        | Description
------------|-------------
OUTPUT_DIR  | Sets the location of the output directory
NPM_BUILD | Override the default "npm run build"
NPM_RUN | Override the default "npx serve" command
DEPLOY_PORT | Override the default(8080) port that the serve module uses
NPM_MIRROR  | Sets the npm registry URL
HTTP_PROXY  | use an npm proxy during assembly
HTTPS_PROXY | use an npm proxy during assembly

One way to define a set of environment variables is to include them as key value pairs
in a `.s2i/environment` file in your source repository.

Example: `DATABASE_USER=sampleUser`

### Using for development

While it is recommended to just use this image as a pure builder image, it can also be used for development.

Taking React as an example, you can deploy your React Application to Openshift using something like this:

`npx nodeshift --strictSSL=false --dockerImage=nodeshift/centos7-s2i-web-app --build.env YARN_ENABLED=true --deploy.env NPM_RUN="yarn start" --deploy.port=3000 --expose`

This will deploy the application and start the React Dev server(yarn start).

Make sure to do this on your code directory, `chmod -R g+w .`, it is needed for the next step

Then you can use the `oc rsync` command to push changes from your local machine to your running deployment:

oc rsync --progress --watch ./src POD_NAME:/opt/app-root/src

_note: a quick way to get a pod name is `oc get pods | grep react-web-app | grep Running | awk '{print $1}'`_

Make a change locally, and it will be pushed to your running deployment, where the react dev server will recompile your app and refresh your browser.
