# OpenShift Builder Images for Web Applications

## Usage

Using this image with OpenShift `oc` command line tool, or with `s2i` directly, will
assemble your application source with its required dependencies, creating a new
container image. This image contains your built Modern Web Application.

The built files will be located in `/opt/app-root/src/$OUTPUT_DIR`

### OpenShift

The [`oc` command-line tool](https://github.com/openshift/origin/releases) can be
used to start a build, layering your desired Web Application `REPO_URL` sources into a centos7
image with your selected `RELEASE` of Node.js via the following command format:

```
oc new-app bucharestgold/centos7-s2i-web-app:latest~https://github.com/bucharest-gold/nodejs-rest-http
```

### Docker

The [Source2Image cli tools](https://github.com/openshift/source-to-image/releases)
are available as a standalone project, allowing you to run your application directly
in Docker.

This example will produce a new Docker image named `webapp`:

```
s2i build https://github.com/bucharest-gold/centos7-s2i-web-app --context-dir=test/test-react-app/ bucharestgold/centos7-s2i-web-app:latest webapp
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
NPM_MIRROR  | Sets the npm registry URL
HTTP_PROXY  | use an npm proxy during assembly
HTTPS_PROXY | use an npm proxy during assembly

One way to define a set of environment variables is to include them as key value pairs
in a `.s2i/environment` file in your source repository.

Example: `DATABASE_USER=sampleUser`

