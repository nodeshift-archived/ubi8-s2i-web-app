#!/bin/bash

set -ex

# Install the nginx web server package and clean the yum cache
yum install -y epel-release
yum install -y --setopt=tsflags=nodocs nginx
yum clean all

# Change the default port for nginx
# Required if you plan on running images as a non-root user).
sed -i 's/80/8080/' /etc/nginx/nginx.conf
sed -i 's/user nginx;//' /etc/nginx/nginx.conf

chown -R 1001:1001 /usr/share/nginx
chown -R 1001:1001 /var/log/nginx
chown -R 1001:1001 /var/lib/nginx
touch /run/nginx.pid
chown -R 1001:1001 /run/nginx.pid
chown -R 1001:1001 /etc/nginx

chmod 777 -R /var/log/nginx
chmod 777 -R /var/lib/nginx /usr/share/nginx/html/ /run

rm -rf /var/log/nginx/error.log
rm -rf /var/log/nginx/access.log
