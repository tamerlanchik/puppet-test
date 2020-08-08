#!/bin/bash
# install docker https://docs.docker.com/engine/install/centos/

# remove previous versions
sudo yum remove docker \
	docker-client \
	docker-client-latest \
	docker-common \
	docker-latest \
 	docker-latest-logrotate \
	docker-logrotate \
	docker-engine
	
# install repo
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# install docker-engine
sudo yum install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
