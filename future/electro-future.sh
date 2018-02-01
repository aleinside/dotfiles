#!/bin/bash
#set -e
#set -x

# configurazione cartelle e host
# notifica https://apple.stackexchange.com/questions/57412/how-can-i-trigger-a-notification-center-notification-from-an-applescript-or-shel<Paste>

### --- ###
# .ssh/config
# export ELECTRO_INSTANCE_ID
### --- ###

### da configurare ###
HOST="prima-dev"
SSH_HOST="dev-future"
DIR_PROJECT=~/Works/prima
REMOTE_PATH="/home/ubuntu"
REMINDER_TIME="1711"
### -------------- ###

LOG_PATH="/tmp/my-sync.log"

INSTANCE_STATUS_CMD="aws ec2 describe-instance-status --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep SYSTEMSTATUS | awk '{print \$2}'"
FSWATCH_CMD="fswatch -o ${DIR_PROJECT} | my_rsync ${DIR_PROJECT} ${SSH_HOST} ${REMOTE_PATH} &"
INSTANCE_DESCRIBE_STATUS_CMD="aws ec2 describe-instances --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep -w STATE |awk '{print \$3}'"

notification_for_mac() {
    local $MSG=$1
    TIME="$(date +'%H%M')"
    if [ ${TIME} != ${REMINDER_TIME} ] ; then
        sleep 50
        notification_for_mac ${MSG} &
    else
        local CHECK_OS=$(uname -s)
        if [[ ${CHECK_OS} == "Darwin" ]]; then
            osascript -e 'display notification "$1" with title "Electro Future"'
        else
            printf "\t === Mi spiace, ma la notifica bella non funziona: $1 === \n"
        fi
    fi
}

my_rsync() {
    local DIR_PRJ=$1
    local HOST=$2
    local REMOTE_PATH=$3
    rsync -aruzv --exclude=.git/ ${DIR_PRJ} ${HOST}:${REMOTE_PATH} >> ${LOG_PATH} 2>&1
}

start_services() {
    printf "Inizio avviando l'istanza ${ELECTRO_INSTANCE_ID}\n"

    aws ec2 start-instances --instance-ids ${ELECTRO_INSTANCE_ID} > /dev/null

    INSTANCE_STATUS=""

    while [ "${INSTANCE_STATUS}" != "ok" ]
    do
        INSTANCE_STATUS=$(eval $INSTANCE_STATUS_CMD)
        sleep 2
        printf "."
    done

    printf "\nIstanza pronta\n"

    #IP_KEY="PRIVATEIPADDRESS"
    IP_KEY="ASSOCIATION"
    INSTANCE_IP=$(aws ec2 describe-instances --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep ${IP_KEY} |head -1 |awk '{print $4}')

    printf "Ottenuto IP ${INSTANCE_IP}: aggiorno ~/.ssh/config e /etc/hosts\n"

    sed "/${HOST}/ s/.*/${INSTANCE_IP}	${HOST}/g" /etc/hosts > /tmp/hostsBK
    cat /tmp/hostsBK | sudo tee /etc/hosts 1> /dev/null
    rm /tmp/hostsBK
    sed "/HostName/ s/.*/HostName ${INSTANCE_IP}/g" ~/.ssh/config > /tmp/sshconfig
    cat /tmp/sshconfig > ~/.ssh/config
    rm /tmp/sshconfig

    printf "Inizializzo fswatch: log su ${LOG_PATH}\n"
    #fswatch -o ${DIR_PROJECT} | my_rsync ${DIR_PROJECT} ${SSH_HOST} ${REMOTE_PATH} &
    $(eval $FSWATCH_CMD) & export ELECTRO_FSWATCH_PID=$!
    printf "(PID per fswatch: ${ELECTRO_FSWATCH_PID})\n"
    printf "Puoi connetterti via ssh con ssh ${SSH_HOST}\n"


}

stop_services() {
    printf "Stoppo l'istanza\n"
    aws ec2 stop-instances --instance-ids ${ELECTRO_INSTANCE_ID} > /dev/null
    sleep 5
    printf "Status: $(eval $INSTANCE_DESCRIBE_STATUS_CMD)\n"
    printf "Killo fswatch\n"
    kill -9 ${ELECTRO_FSWATCH_PID}
}

check() {
    local INSTANCE_STATUS=$(eval $INSTANCE_DESCRIBE_STATUS_CMD)
    printf "Status dell'istanza: ${INSTANCE_STATUS}\n"
    ps cax |grep fswatch > /dev/null
    if [ $? -eq 0 ]; then
        printf "fswatch è attivo\n"
    else
        printf "fswatch non è attivo\n"
    fi
}

rewatch() {
    printf "Rilancio fswatch\n"
    $(eval $FSWATCH_CMD) & export ELECTRO_FSWATCH_PID=$!
    printf "(PID per fswatch: ${ELECTRO_FSWATCH_PID})\n"
}

logwatch() {
    printf "Log di fswatch:\n\n"
    tail -f ${LOG_PATH}
}

usage() {
    printf "Utilizzo ${0}:\n"
    printf "   start: avvia la macchina e fswatch\n"
    printf "   stop: stoppa fswatch e la macchina\n"
    printf "   check: controlla lo stato della macchina e di fswatch\n"
    printf "   rewatch: rilancia fswatch\n"
    printf "   logwatch: controlla i log di fswatch\n"
    printf "   test-notification: testa le notifiche alle ${REMINDER_TIME}"
}

main() {
    local cmd=$1

    if [ -z ${ELECTRO_INSTANCE_ID+x} ]; then
        printf "Per favore, configura la variabile ELECTRO_INSTANCE_ID\n"
        exit
    else
        printf "INSTANCE ID: ${ELECTRO_INSTANCE_ID}\n"
    fi


    if [[ -z "$cmd" ]]; then
        usage
        exit 1
    fi

    if [[ $cmd == "start" ]]; then
        start_services
    elif [[ $cmd == "stop" ]]; then
        stop_services
    elif [[ $cmd == "check" ]]; then
        check
    elif [[ $cmd == "rewatch" ]]; then
        rewatch
    elif [[ $cmd == "logwatch" ]]; then
        logwatch
    elif [[ $cmd == "test-notification" ]]; then
        notification_for_mac "Test notification" &
    else
        usage
    fi
}

main "$@"
