#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# avoid interactive installation
export DEBIAN_FRONTEND=noninteractive

install_oh_my_zsh() {
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    sudo chsh ubuntu -s /bin/zsh
}

install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

install_nerd_fonts() {
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf
}

install_universal_ctags() {
    git clone https://github.com/universal-ctags/ctags.git
    cd ctags
    ./autogen.sh
    ./configure
    make
    sudo make install
}

install_neovim() {
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
}

install_asdf() {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
}

install_dotfiles() {
    local DOTDIR=~/Works/dotfiles
    cat ${DOTDIR}/aliases >> ~/.zshrc
    cp ${DOTDIR}/tmux.conf ~/.tmux.conf
    cp ${DOTDIR}/ctags ~/.ctags
    cp ${DOTDIR}/git/gitconfig ~/.gitconfig
    cp ${DOTDIR}/git/gitignore_global ~/.gitignore_global
    mkdir -p ~/.config/nvim
    cp ${DOTDIR}/vim/wip-init.vim ~/.config/nvim/init.vim
    cp ${DOTDIR}/default-gems ~/.default-gems
}

install_packages() {
    sudo apt-get install -y htop zsh tree tig tmux jq silversearcher-ag dh-autoreconf libncurses5-dev unzip zlib1g-dev libreadline6 libreadline6-dev bzip2 libssl-dev libsqlite3-dev libbz2-dev libgdbm3
}

#setup `mkdir ~/Works && git clone git@github.com:aleinside/dotfiles.git ~/Works/dotfiles`

install_packages
install_oh_my_zsh
install_fzf
install_nerd_fonts
install_universal_ctags
install_neovim
install_asdf
install_dotfiles

echo "\n Esci e rientra per cambiare shell e rendere attive le modifiche: ricordati anche di asdf.sh!"
