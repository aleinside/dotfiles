#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

readonly reset=$(tput sgr0)
readonly green=$(tput setaf 76)

e_arrow() {
    printf "➜ %s\\n" "$@"
}

e_success() {
    printf "${green}✔ %s${reset}\\n" "$@"
}

e_arrow "Faccio il backup della configurazione"
mv ~/.config/nvim ~/.config/nvim_$(date +'%s').BK

e_arrow "Ricreo la cartella"
mkdir ~/.config/nvim

e_arrow "Copio la configurazione"
cp $(pwd)/init.vim ~/.config/nvim/init.vim
cp -R $(pwd)/config ~/.config/nvim

e_success "Finito!"
