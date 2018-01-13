#!/bin/bash

# USAGE: sh -c "$(curl -fsSL https://raw.githubusercontent.com/aleinside/dotfiles/master/future/bootstrap.sh)"

echo "export LANG=en_US.UTF-8" | tee --append $HOME/.bashrc
echo "export LANGUAGE=en_US.UTF-8" | tee --append $HOME/.bashrc
echo "export LC_ALL=en_US.UTF-8" | tee --append $HOME/.bashrc

sudo apt-get update
sudo apt-get install -y awscli libcurl4-openssl-dev cmake pkg-config 
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker $USER

sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# da mettere all'avvio dell'istanza
# echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8Fe5JeRcpLfHE6c7tSjPuTOmfoNznHK8bxbvuPed2EiovdG0zC683NWHeFisa/mW2nbQi4KzmdhaBCAfCX6Ky+4GzGw6YoVt3TtTF45K3dkYgcv09J/BAicrWrKYCpr8EzNsc1fFwaGFJQz+uvVbOvz3DsxQMXHPiCalXEx2y2CW7FWcnDxRMVTxf22uVeOqymh8+LdZwD4n2u5QWeUfMJpbYFe79YZiF+XUbUMgHauQFjb4IEmURL8/L8TW6QPeLwWvDJ39kC+bjKDdXim41y2HVE4SJkkGUNKwjqNTQTqXFAaOioRKuk9DayDAN6Vh1n3CTcoJLxCHfw1zwF6LbDytSFxUQDRfvtgi9NGSlSy0xRhJHHBQ+LLtatxz1JhFfo7v3B3e+igLUQVqHzOcj952jf+IlXeyp3s2HPYSv7LTcTetpUPk1KCYQY/CizyFhbhvcCfKzSsLy3acc/qlMQEv3XkbbhDsQfdYO4eU/W3iCFEcXb7HcfRFJ0SPT2gO1puTnO2ZtA94P+oQgWTpbWr/1GLR8N9c6u0LdYk9fP3L7QeBcHdJFhzmn02WqZXTqxx3Y9QxO5W0tcATzPIK8oqN2uFcUy21zbAZmP+/qh+A2tHKLJRfmyBdFGTxB2U3ap5Ah2sUF3xnki43eKFm3g01xUxOa0tYUdsyBvul76w== aleinside@gmail.com" >> ~/.ssh/authorized_keys

