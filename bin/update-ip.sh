#! /bin/bash

IP=$1
HOST="prima-dev"

sed "/${HOST}/ s/.*/${IP}	${HOST}/g" /etc/hosts > /tmp/hostsBK
cat /tmp/hostsBK | sudo tee /etc/hosts
rm /tmp/hostsBK
sed "/HostName/ s/.*/HostName ${IP}/g" ~/.ssh/config > /tmp/sshconfig
cat /tmp/sshconfig > ~/.ssh/config
rm /tmp/sshconfig
