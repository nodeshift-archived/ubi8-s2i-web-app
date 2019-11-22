# Makes the ubi8-s2i-nodejs image.
make all

# Login into openshift docker registry.
docker login -u `oc whoami` -p `oc whoami -t` 172.30.1.1:5000

# Creates a new project.
oc new-project nodeshift

# Creates a tag on openshift docker registry based on the local created image.
docker tag nodeshift/ubi8-s2i-web-app:12.x 172.30.1.1:5000/nodeshift/ubi8-s2i-web-app:12.x

# Pushes the image to the openshift docker registry.
docker push 172.30.1.1:5000/nodeshift/ubi8-s2i-web-app:12.x

# Creates a new app based on the pushed image.
oc new-app 172.30.1.1:5000/nodeshift/ubi8-s2i-web-app:12.x~https://github.com/lholmquist/react-web-app

# Exposes to confirm that the app was successfully deployed.
timeout 1m oc expose svc/react-web-app
