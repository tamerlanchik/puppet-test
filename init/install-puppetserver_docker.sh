#!/bin/bash
# installing puppet-server

server_names=${1?"Need puppetserver address at \$1"

# getting archive
if [[ ! -f "~/pupperware.zip" ]]; then
      curl -L https://github.com/puppetlabs/pupperware/archive/master.zip -o ~/pupperware.zip;
fi

if [[ ! -d "~/pupperware" ]]; then
  yum install -y unzip
  unzip ~/pupperware.zip;
  rm ~/pupperware.zip;
fi

cd ~/pupperware

if [[ ! -f "/usr/local/bin/docker-compose" ]]; then
  ./install-docker-compose.sh;
fi

DNS_ALT_NAMES=$server_names /usr/local/bin/docker-compose up -d

echo "Puppetmaster installed and switched on!"
