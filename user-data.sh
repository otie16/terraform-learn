#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
usermod -aG docker jenkins
chmod 777 /var/run/docker.sock
docker run -d -p 8080:80 nginx