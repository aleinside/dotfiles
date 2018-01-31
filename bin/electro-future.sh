#!/bin/bash
set -e

# salvare IP pubblico se VPN non sta su
# opzione per spegnere la macchina
# opzione per killare o rilanciare fswatch
# opzione per la visualizzazion log
# configurazione cartelle e host
# notifica https://apple.stackexchange.com/questions/57412/how-can-i-trigger-a-notification-center-notification-from-an-applescript-or-shel<Paste>

# validare, perchè poi passato al CMD
INSTANCE_ID=$1

HOST="prima-dev"
SSH_HOST="dev-future"
DIR_PROJECT=~/Works/prima
REMOTE_PATH="/home/ubuntu/future"

printf "Inizio avviando l'istanza ${INSTANCE_ID}\n"

#aws ec2 start-instances --instance-ids ${INSTANCE_ID} > /dev/null

INSTANCE_STATUS_CMD="aws ec2 describe-instance-status --instance-ids ${INSTANCE_ID} --output text |grep SYSTEMSTATUS | awk '{print \$2}'"
INSTANCE_STATUS=""

while [ "${INSTANCE_STATUS}" != "ok" ]
do
	INSTANCE_STATUS=$(eval $INSTANCE_STATUS_CMD)
	sleep 2
	printf "."
done

printf "\nIstanza pronta\n"

INSTANCE_IP=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --output text |grep PRIVATEIPADDRESSES |head -1 |awk '{print $4}')

printf "Ottenuto IP ${INSTANCE_IP}: aggiorno ~/.ssh/config e /etc/hosts\n"

sed "/${HOST}/ s/.*/${INSTANCE_IP}	${HOST}/g" /etc/hosts > /tmp/hostsBK
cat /tmp/hostsBK | sudo tee /etc/hosts 1> /dev/null
rm /tmp/hostsBK
sed "/HostName/ s/.*/HostName ${INSTANCE_IP}/g" ~/.ssh/config > /tmp/sshconfig
cat /tmp/sshconfig > ~/.ssh/config
rm /tmp/sshconfig

function my_rsync() {
	local DIR_PRJ=$1
	local HOST=$2
	local REMOTE_PATH=$3
    printf "Sono qui\n"
	rsync -aruzv --exclude=.git/ ${DIR_PRJ} ${HOST}:${REMOTE_PATH} >> /tmp/my-sync.log 2>&1
    printf "E qui\n"
}

printf "Inizializzo fswatch: log su /tmp/my-sync.log\n"

fswatch -o ${DIR_PROJECT} | my_rsync ${DIR_PROJECT} ${SSH_HOST} ${REMOTE_PATH} &

printf "(PID per fswatch: $!)\n"

printf "Puoi connetterti via ssh con ssh ${SSH_HOST}\n"
