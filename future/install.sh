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
    echo 'alias doc="docker-compose"' >> ~/.zshrc
    echo 'alias vim="nvim"' >> ~/.zshrc
    echo 'ZSH_THEME="bira"' >> ~/.zshrc
    cp ${DOTDIR}/tmux.conf ~/.tmux.conf
    cp ${DOTDIR}/ctags ~/.ctags
    cp ${DOTDIR}/git/gitconfig ~/.gitconfig
    cp ${DOTDIR}/git/gitignore_global ~/.gitignore_global
    mkdir -p ~/.config/nvim
    cp ${DOTDIR}/vim/wip-init.vim ~/.config/nvim/init.vim
    git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac
    cp ${DOTDIR}/default-gems ~/.default-gems
}

install_packages() {
    sudo apt-get install -y \
        htop \
        zsh \
        tree \
        tig \
        tmux \
        jq \
        silversearcher-ag \
        dh-autoreconf \
        libncurses5-dev \
        unzip \
        bzip2 \
        libsqlite3-dev \
        libbz2-dev \
        libgdbm3 \
        curl \
        build-essential \
        autoconf \
        libjpeg-dev \
        libpng12-dev \
        openssl \
        libssl-dev \
        libcurl4-openssl-dev \
        pkg-config \
        libsslcommon2-dev \
        libreadline-dev \
        libedit-dev \
        zlib1g-dev \
        libicu-dev \
        libxml2-dev \
        gettext \
        bison \
        libmysqlclient-dev \
        libpq-dev

}

install_phpcs() {
    curl -L http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o php-cs-fixer
    sudo chmod a+x php-cs-fixer
    sudo mv php-cs-fixer /usr/local/bin/php-cs-fixer
}

install_tpm() {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

#setup `mkdir ~/Works && git clone git@github.com:aleinside/dotfiles.git ~/Works/dotfiles`

install_packages
install_oh_my_zsh
install_fzf
#install_nerd_fonts
install_universal_ctags
install_neovim
install_asdf
install_phpcs
install_tpm
install_dotfiles

echo "Esci e rientra per cambiare shell e rendere attive le modifiche: ricordati anche di asdf.sh!"
