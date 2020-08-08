#!/bin/bash
# install docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

if [[ ! "$PATH" =~ /\/usr\/local\/bin\// ]]; then
  if [[ ! -f "/etc/profile.d/path.sh" ]]; then
      sudo echo "#!/bin/bash" >> /etc/profile.d/path.sh;
  fi
  sudo echo "pathmunge /usr/local/bin/ after" >> /etc/profile.d/path.sh
fi

docker-compose --version

echo "Docker compose installed!"
