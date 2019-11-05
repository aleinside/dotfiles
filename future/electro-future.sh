#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# TODO: watch list: visualizza lo stato di fswatch

# configuration variables, read from config file
ELECTRO_INSTANCE_ID="i-xxx"
HOST="prima"
SSH_HOST="dev-prima"
# opzionali
REMOTE_PATH="/home/ubuntu"
REMINDER_TIME="1750"

readonly ping_vpn="10.254.0.250"
readonly config_path=~/.config/electro/
readonly config_file="config"
readonly script_url="https://raw.githubusercontent.com/aleinside/dotfiles/master/future/electro-future.sh"
readonly log_path="/tmp/electro-log/"
readonly rsync_options="--exclude=.git/ --exclude=vendor/ --exclude=node_modules/ --exclude=web/assets/ --exclude=web/compass/stylesheets/ --exclude=web/bundles/ --exclude=var/cache/ --exclude=var/logs/ --exclude=var/sessions/ --exclude=elm-stuff/ --exclude=_build/ --exclude=deps/ --exclude=web/js/ --exclude=dist/ --exclude=target/ --exclude=target-docker/ --exclude=public/assets/ --exclude=public/compass/stylesheets/ --exclude=public/bundles/ --exclude=public/js/ "
readonly bold=$(tput bold)
readonly reset=$(tput sgr0)
readonly purple=$(tput setaf 171)
readonly red=$(tput setaf 1)
readonly green=$(tput setaf 76)
readonly tan=$(tput setaf 3)

e_header() {
    printf "\\n${bold}${purple}==========  %s  ==========${reset}\\n" "$@"
}

e_arrow() {
    printf "➜ %s\\n" "$@"
}

e_success() {
    printf "${green}✔ %s${reset}\\n" "$@"
}

e_error() {
    printf "${red}✖ %s${reset}\\n" "$@"
}

e_warning() {
    printf "${tan}➜ %s${reset}\\n" "$@"
}

notify() {
    osascript -e "display notification \"$*\" with title \"Electro Future\""
}

notification_for_mac() {
    local time
    local check_os
    time="$(date +'%H%M')"
    if [ "${time}" != "${REMINDER_TIME}" ] ; then
        sleep 50
        notification_for_mac "$*" &
    else
        check_os=$(uname -s)
        if [[ ${check_os} == "Darwin" ]]; then
            notify "$*"
        else
            printf "\\t === Mi spiace, ma la notifica bella non funziona: %s === \\n" "$*"
        fi
    fi
}

check_vpn() {
    set +e
    if ! ping -c2 -q "${ping_vpn}" > /dev/null; then
        e_warning "Non hai attivato la VPN!"
        exit
    fi
    set -e
    true
}

get_project() {
    basename "$(pwd)"
}

kill_fswatch() {
    set +e
    fswatch_pid=$(cat "${log_path}$(get_project).pid")
    kill -9 "${fswatch_pid}"
    set -e
}

start_services() {
    local check_os
    local instance_status
    local oldip
    local ip_key
    local instance_ip
    local k

    e_header "Inizio avviando l'istanza ${ELECTRO_INSTANCE_ID}"

    check_vpn

    check_os=$(uname -s)
    if [[ ${check_os} == "Darwin" ]]; then
        ssh-add -K ~/.ssh/id_rsa
    else
        ssh-add ~/.ssh/id_rsa
    fi

    instance_status=$(eval "${instance_describe_status_cmd}")
    if [[ "${instance_status}" == "stopped" ]]; then
        aws ec2 start-instances --instance-ids "${ELECTRO_INSTANCE_ID}" > /dev/null
        # bisogna slippare
        for k in $(seq 1 5);
        do
            printf "."
            sleep 2
        done
        while [[ "${instance_status}" != "ok" ]]
        do
            instance_status=$(eval "${instance_status_cmd}")
            sleep 2
            printf "."
        done
    fi
    printf "\\n"

    e_success "Istanza pronta"

    ip_key="PRIVATEIPADDRESS"
    #ip_key="ASSOCIATION"
    instance_ip=$(aws ec2 describe-instances --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep ${ip_key} |head -1 |awk '{print $4}')

    e_success "Ottenuto IP ${instance_ip}"
    e_warning "Aggiorno ~/.ssh/config e /etc/hosts"

    sed "/${HOST}/ s/.*/${instance_ip}	${HOST}/g" /etc/hosts > /tmp/hostsBK
    cat /tmp/hostsBK | sudo tee /etc/hosts 1> /dev/null
    rm /tmp/hostsBK
    #sed "/HostName/ s/.*/HostName ${INSTANCE_IP}/g" ~/.ssh/config > /tmp/sshconfig
    oldip=$(grep -w ${SSH_HOST} -A 1 ~/.ssh/config | awk '/HostName/ {print $2}')
    sed "s/${oldip}/${instance_ip}/g" ~/.ssh/config > /tmp/sshconfig
    cat /tmp/sshconfig > ~/.ssh/config
    rm /tmp/sshconfig

    if should_start_fswatch "$@"; then
        watch
    fi

    e_success "Ora puoi lanciare electro watch nelle cartelle dei progetti"
    e_success "Ricorda: puoi connetterti via ssh con ssh ${SSH_HOST}"

    notification_for_mac "Ricordati di spegnere la macchina remota!" &
}

should_start_fswatch() {
    local status=true
    for var in "$@"
    do
        if [ "${var}" == "--nowatch" ]; then
            status=false
            break
        fi
    done
    ${status}
}

stop_services() {
    local instance_status
    e_warning "Stoppo l'istanza"
    aws ec2 stop-instances --instance-ids ${ELECTRO_INSTANCE_ID} > /dev/null
    sleep 5
    instance_status=$(eval "${instance_describe_status_cmd}")
    e_warning "Status: ${instance_status}"
    e_warning "Killo fswatch"
    killall_fswatch
}

check() {
    local instance_status
    local fswatch_pid
    local pid_file
    check_vpn
    instance_status=$(eval "${instance_describe_status_cmd}")
    if [[ "${instance_status}" != "running" ]]; then
        e_error "Stato dell'istanza: ${instance_status}"
    else
        e_success "Stato dell'istanza: ok"
    fi
    set +e
    pid_file="${log_path}$(get_project).pid"
    fswatch_pid=$(cat "${pid_file}" 2> /dev/null)
    if ps -p "${fswatch_pid}" &> /dev/null; then
        e_success "fswatch è attivo"
    else
        e_error "fswatch non è attivo"
    fi
    set -e
}

killall_fswatch() {
    set +e
    # local status=$?
    # if $(exit status); then
    if pgrep fswatch > /dev/null; then
        kill $(pgrep fswatch |awk '{print $1}')
    fi
    set -e
}

watch() {
    local logfile
    local pidfile
    local pid
    logfile="${log_path}$(get_project).log"
    pidfile="${log_path}$(get_project).pid"
    e_warning "Inizializzo fswatch: log su ${logfile}"

    if eval "${fswatch_cmd} &" ; then
        #pid=$!
        pid=$(jobs -p)
        e_warning "PID: ${pid}"
        touch "${pidfile}"
        echo "${pid}" > "${pidfile}"
        e_success "Fswatch lanciato"
    else
        e_error "Problemi con fswatch"
    fi
}

stopwatch() {
    e_warning "Killo fswatch"
    kill_fswatch
    e_success "Fswatch killato"
}

logwatch() {
    local logfile
    logfile="${log_path}$(get_project).log"
    e_header "Log di fswatch"
    tail -f "${logfile}"
}

update() {
    local scriptpath
    local scriptname
    local random_string
    scriptpath=$( cd "$(dirname "$0")" ; pwd -P )
    scriptname=$(basename "$0")
    e_header "Procedo con l'aggiornamento dello script"
    e_arrow "Salvo in ${scriptpath}/${scriptname}"
    random_string=$(date +"%s")
    if curl -fsSL "${script_url}"?ran="${random_string}" -o "${scriptpath}/${scriptname}"; then
        e_success "Aggiornamento riuscito!"
    else
        e_error "Problemi nell'aggiornamento"
    fi
    # TODO: creare file rsync
}

usage() {
    e_header "Utilizzo electro:"
    e_arrow "start:       avvia la macchina. con --nowatch evita di lanciare il watch"
    e_arrow "stop:        stoppa fswatch e la macchina"
    e_arrow "check:       controlla lo stato della macchina e di fswatch"
    e_arrow "watch:       lancia fswatch"
    e_arrow "stopwatch:   killa fswatch"
    e_arrow "log:         controlla i log di fswatch"
    e_arrow "update:      aggiorna lo script"
    e_arrow "dc <cmd>:    esegue il comando 'docker-compose <cmd>' sulla macchina di sviluppo"
    e_arrow "test-notification:   testa le notifiche alle ${REMINDER_TIME}"
    printf "\\n"
    e_warning "Ricordati di eseguire i comandi nella cartella del progetto sul quali vuoi lavorare!"
    printf "\\n"
}

doc_exec() {
    local parameters
    parameters="${@:2}"
    ssh "${SSH_HOST}" "cd ${REMOTE_PATH}/$(get_project);docker-compose ${parameters}"
}

main() {
    local cmd=${1:-}
    local logfile

    if [ ! -f "${config_path}${config_file}" ]; then
        e_warning "Creo file di configurazione in ${config_path}"
        mkdir -p ${config_path}
        touch ${config_path}${config_file}
        echo 'ELECTRO_INSTANCE_ID="i-xxx"
HOST="prima"
SSH_HOST="dev-prima"
' > ${config_path}${config_file}

        e_warning "Ricordati di configurare il file!"
        exit
    fi

    if [[ -z "$cmd" ]]; then
        usage
        exit 1
    fi

    if [ ! -d "${log_path}" ]; then
        mkdir "${log_path}"
    fi

    source "${config_path}${config_file}"

    logfile="${log_path}$(get_project).log"
    instance_status_cmd="aws ec2 describe-instance-status --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep SYSTEMSTATUS | awk '{print \$2}'"
    fswatch_cmd="fswatch -o $(pwd) | xargs -n1 -I{} rsync -aruzvq --delete --log-file=${logfile} ${rsync_options} $(pwd) ${SSH_HOST}:${REMOTE_PATH}"
    instance_describe_status_cmd="aws ec2 describe-instances --instance-ids ${ELECTRO_INSTANCE_ID} --output text |grep -w STATE |awk '{print \$3}'"
    if [[ $cmd == "start" ]]; then
        start_services "$@"
    elif [[ $cmd == "stop" ]]; then
        stop_services
    elif [[ $cmd == "check" ]]; then
        check
    elif [[ $cmd == "watch" ]]; then
        watch
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
