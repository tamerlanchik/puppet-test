#!/bin/bash
# installing puppet-server

server_names=${1?"Need puppetserver address at \$1"}

# getting archive
if [[ ! -f "~/pupperware.zip" ]]; then
      curl -L https://github.com/puppetlabs/pupperware/archive/master.zip -o ~/pupperware.zip;
fi

if [[ ! -d "~/pupperware" ]]; then
  sudo yum install -y unzip
  unzip ~/pupperware.zip
  sudo mv ~/pupperware-master /usr/src/pupperware;
  rm ~/pupperware.zip;
fi

# if [[ ! -f "/usr/local/bin/docker-compose" ]]; then
#   ./install-docker-compose.sh;
# fi

cat > ~/docker-compose-puppetmaster.service <<- EOF
# /etc/systemd/system/docker-compose-puppetmaste.service
[Unit]
Description=Docker Compose Puppetmaster
Requires=docker.service
After=docker.service

[Service]
Restart=always
WorkingDirectory=/usr/src/pupperware
ExecStart=/usr/local/bin/docker-compose up -f docker-compose.yml -d
ExecStop=/usr/local/bin/docker-compose down

[Install]
WantedBy=multi-user.target
EOF

sudo mv ~/docker-compose-puppetmaster.service /etc/systemd/system/docker-compose-puppetmaster.service || exit 1

cd /usr/src/pupperware || exit 1
# First run requires DNS_ALT_NAMES for setup
sudo DNS_ALT_NAMES=$server_names /usr/local/bin/docker-compose up -d || exit 1

sudo systemctl enable docker-compose-puppetmaster

echo "Puppetmaster installed and switched on!"
