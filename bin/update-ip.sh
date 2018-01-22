#! /bin/bash

IP=$1
HOST="prima-dev"

sed "/${HOST}/ s/.*/${IP}	${HOST}/g" /etc/hosts | sudo tee /etc/hosts
sed "/HostName/ s/.*/HostName ${IP}/g" ~/.ssh/config > ~/.ssh/config
