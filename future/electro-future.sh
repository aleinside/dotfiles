#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
ELECTRO_DEBUG="0"
if [[ "1" == $ELECTRO_DEBUG ]]; then
    set -x
fi

# configuration vabiables, read from config file
ELECTRO_INSTANCE_ID="i-xxx"
HOST="prima"
SSH_HOST="dev-prima"
DIR_PROJECT=""
# opzionale
REMOTE_PATH="/home/ubuntu"
# opzionale
REMINDER_TIME="1750"


PING_VPN="10.33.4.8"
CONFIG_PATH=~/.config/electro/
CONFIG_FILE="config"
SCRIPT_URL="https://raw.githubusercontent.com/aleinside/dotfiles/master/future/electro-future.sh"
LOG_PATH="/tmp/electro-sync.log"

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

e_header() {
    printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@"
}

e_arrow() {
    printf "➜ $@\n"
}

e_success() {
    printf "${green}✔ %s${reset}\n" "$@"
}

e_error() {
    printf "${red}✖ %s${reset}\n" "$@"
}

e_warning() {
    printf "${tan}➜ %s${reset}\n" "$@"
}

notify() {
    osascript -e "display notification \"$*\" with title \"Electro Future\""
}

notification_for_mac() {
    local TIME="$(date +'%H%M')"
    if [ ${TIME} != ${REMINDER_TIME} ] ; then
        sleep 50
        notification_for_mac $* &
    else
        local CHECK_OS=$(uname -s)
        if [[ ${CHECK_OS} == "Darwin" ]]; then
            notify $*
        else
            printf "\t === Mi spiace, ma la notifica bella non funziona: $* === \n"
        fi
    fi
}

check_vpn() {
    set +e
    ping ${PING_VPN} -c 2 > /dev/null
    if [ ! $? -eq 0 ]; then
        e_warning "Non hai attivato la VPN!"
        exit
    fi
    set -e
}

kill_fswatch() {
    set +e
    # local status=$?
    # if $(exit status); then
    ps cax |grep fswatch > /dev/null
    if [ $? -eq 0 ]; then
        kill $(ps cax |grep fswatch |awk '{print $1}')
    fi
    set -e
}

should_start_fswatch() {
    local status=true
    for var in "$@"
    do
        if [ $var == "--nowatch" ]; then
            status=false
            break
        fi
    done
    ${status}
}

start_services() {
    e_header "Inizio avviando l'istanza ${ELECTRO_INSTANCE_ID}"

    check_vpn

    local CHECK_OS=$(uname -s)
    if [[ ${CHECK_OS} == "Darwin" ]]; then
        ssh-add -K ~/.ssh/id_rsa
    else
        ssh-add ~/.ssh/id_rsa
    fi

    local INSTANCE_STATUS=$(eval $INSTANCE_DESCRIBE_STATUS_CMD)
    if [[ ${INSTANCE_STATUS} == "stopped" ]]; then
        aws ec2 start-instances --instance-ids ${ELECTRO_INSTANCE_ID} > /dev/null
        while [ "${INSTANCE_STATUS}" != "ok" ]
        do
            INSTANCE_STATUS=$(eval $INSTANCE_STATUS_CMD)
            sleep 2
            printf "."
        done
    fi

    e_success "Istanza pronta"

    IP_KEY="PRIVATEIPADDRESS"
    #IP_KEY="ASSOCIATION"
    INSTANCE_IP=$(aws ec2 describe-instances --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep ${IP_KEY} |head -1 |awk '{print $4}')

    e_success "Ottenuto IP ${INSTANCE_IP}"
    e_warning "Aggiorno ~/.ssh/config e /etc/hosts"

    sed "/${HOST}/ s/.*/${INSTANCE_IP}	${HOST}/g" /etc/hosts > /tmp/hostsBK
    cat /tmp/hostsBK | sudo tee /etc/hosts 1> /dev/null
    rm /tmp/hostsBK
    #sed "/HostName/ s/.*/HostName ${INSTANCE_IP}/g" ~/.ssh/config > /tmp/sshconfig
    local OLDIP=$(grep -w ${SSH_HOST} -A 1 ~/.ssh/config | awk '/HostName/ {print $2}')
    sed "s/${OLDIP}/${INSTANCE_IP}/g" ~/.ssh/config > /tmp/sshconfig
    cat /tmp/sshconfig > ~/.ssh/config
    rm /tmp/sshconfig

    if should_start_fswatch "$@"; then
        e_warning "Inizializzo fswatch: log su ${LOG_PATH}"
        $(eval $FSWATCH_CMD) &
        if [ $? -eq 0 ]; then
            e_success "Fswatch lanciato"
        else
            e_error "Problemi con fswatch"
        fi
    fi
    e_success "Puoi connetterti via ssh con ssh ${SSH_HOST}"

    notification_for_mac "Ricordati di spegnere la macchina remota!" &
}

stop_services() {
    e_warning "Stoppo l'istanza"
    aws ec2 stop-instances --instance-ids ${ELECTRO_INSTANCE_ID} > /dev/null
    sleep 5
    e_warning "Status: $(eval $INSTANCE_DESCRIBE_STATUS_CMD)"
    e_warning "Killo fswatch"
    kill_fswatch
}

check() {
    local INSTANCE_STATUS=$(eval $INSTANCE_DESCRIBE_STATUS_CMD)
    if [[ ${INSTANCE_STATUS} != "running" ]]; then
        e_error "Stato dell'istanza: ${INSTANCE_STATUS}"
    else
        e_success "Stato dell'istanza: ok"
    fi
    set +e
    ps cax |grep fswatch > /dev/null
    if [ $? -eq 0 ]; then
        e_success "fswatch è attivo"
    else
        e_error "fswatch non è attivo"
    fi
    set -e
}

rewatch() {
    kill_fswatch
    e_warning "Rilancio fswatch"
    $(eval $FSWATCH_CMD) &
    e_success "Fswatch rilanciato"
}


stopwatch() {
    e_warning "Killo fswatch"
    kill_fswatch
    e_success "Fswatch killato"
}

logwatch() {
    e_header "Log di fswatch"
    tail -f ${LOG_PATH}
}

update() {
    local SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
    local SCRIPTNAME=$(basename "$0")
    e_header "Procedo con l'aggiornamento dello script"
    e_arrow "Salvo in ${SCRIPTPATH}/${SCRIPTNAME}"
    curl -fsSL ${SCRIPT_URL}?ran=$(date +"%s") -o ${SCRIPTPATH}/${SCRIPTNAME}
    if [ $? -eq 0 ]; then
        e_success "Aggiornamento riuscito!"
    else
        e_error "Problemi nell'aggiornamento"
    fi
}

usage() {
    e_header "Utilizzo $(basename $0)"
    e_arrow "start:\t\t avvia la macchina e fswatch se non viene passata l'opzione --nowatch"
    e_arrow "stop:\t\t\t stoppa fswatch e la macchina"
    e_arrow "check:\t\t controlla lo stato della macchina e di fswatch"
    e_arrow "rewatch:\t\t rilancia fswatch"
    e_arrow "stopwatch:\t\t killa fswatch"
    e_arrow "log:\t\t\t controlla i log di fswatch"
    e_arrow "update:\t\t aggiorna lo script"
    e_arrow "test-notification:\t testa le notifiche alle ${REMINDER_TIME}"
    e_arrow "dc <cmd>:\t\t esegue il comando 'docker-compose <cmd>' sulla macchina di sviluppo"
    printf "\n"
    e_warning "per debug esegui: ELECTRO_DEBUG=1 electro <cmd>"
    printf "\n"
}

doc_exec() {
    ssh ${SSH_HOST} "cd ${REMOTE_PATH}/$(basename $DIR_PROJECT);docker-compose "${@:2}""
}

main() {
    local cmd=${1:-}

    if [ ! -f ${CONFIG_PATH}${CONFIG_FILE} ]; then
        e_warning "Creo file di configurazione in ${CONFIG_PATH}"
        mkdir -p ${CONFIG_PATH}
        touch ${CONFIG_PATH}${CONFIG_FILE}
        echo 'ELECTRO_INSTANCE_ID="i-xxx"
HOST="prima"
SSH_HOST="dev-prima"
DIR_PROJECT=~/Documents/prima
' > ${CONFIG_PATH}${CONFIG_FILE}

        e_warning "Ricordati di configurare il file!"
        exit
    fi
    #if [ -z ${ELECTRO_INSTANCE_ID+x} ]; then
    #    printf "Per favore, configura la variabile ELECTRO_INSTANCE_ID\n"
    #    exit
    #fi

    if [[ -z "$cmd" ]]; then
        usage
        exit 1
    fi

    source ${CONFIG_PATH}${CONFIG_FILE}

    INSTANCE_STATUS_CMD="aws ec2 describe-instance-status --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep SYSTEMSTATUS | awk '{print \$2}'"
    FSWATCH_CMD="fswatch -o ${DIR_PROJECT} | xargs -n1 -I{} rsync -aruzvq --delete --log-file=${LOG_PATH} --exclude=.git/ --exclude=vendor/ --exclude=node_modules/ --exclude=web/assets/ --exclude=web/bower/ --exclude=web/compass/ --exclude=web/bundles/ --exclude=web/webpack/ --exclude=var/cache/ --exclude=var/logs/ --exclude=var/sessions/ --exclude=elm-stuff/ --exclude=app/data/ ${DIR_PROJECT} ${SSH_HOST}:${REMOTE_PATH}"
    INSTANCE_DESCRIBE_STATUS_CMD="aws ec2 describe-instances --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep -w STATE |awk '{print \$3}'"
    if [[ $cmd == "start" ]]; then
        start_services "$@"
    elif [[ $cmd == "stop" ]]; then
        stop_services
    elif [[ $cmd == "check" ]]; then
        check
    elif [[ $cmd == "rewatch" ]]; then
        rewatch
    elif [[ $cmd == "stopwatch" ]]; then
        stopwatch
    elif [[ $cmd == "log" ]]; then
        logwatch
    elif [[ $cmd == "test-notification" ]]; then
        notify "Test notification" &
    elif [[ $cmd == "update" ]]; then
        update
    elif [[ $cmd == "dc" ]]; then
        doc_exec "$@"
    else
        usage
    fi
}

main "$@"
