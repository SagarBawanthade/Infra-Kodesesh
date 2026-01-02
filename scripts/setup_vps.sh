#!/bin/sh

echo "Checking Docker..."
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi

sudo systemctl enable docker
sudo systemctl start docker

echo "Ensuring Docker network exists..."
sudo docker network inspect kodesesh-network >/dev/null 2>&1 || \
sudo docker network create kodesesh-network

echo "Ensuring env file exists..."
sudo touch /home/sagar/kodesesh.env
sudo chown sagar:sagar /home/sagar/kodesesh.env

echo "VPS base setup complete"
