#!/bin/bash

set -eux

# update and upgrade
sudo apt-get update ;
sudo apt-get upgrade -y ;
# install Docker
curl -Lq https://get.docker.com | sh - ;
# make sure docker is run in rootless mode
dockerd-rootless-setuptool.sh install ;
# place docker specific env vars in .profile
echo "export PATH=\"/usr/bin:\${PATH}\"" >> .profile
echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> .profile
# install K3s
curl -sfL https://get.k3s.io | sh -

set +eux

echo "Installation completed successfully"