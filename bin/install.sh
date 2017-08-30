#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# avoid interactive installation
export DEBIAN_FRONTEND=noninteractive

install_google_chrome() {
    # Add the Google Chrome distribution URI as a package source
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/google-chrome.list

    # Import the Google Chrome public key
    curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

    sudo apt-get update
    sudo apt-get install google-chrome-stable
}

install_packages() {
    cat packages | xargs sudo apt-get install -y
}

install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

install_nerd_fonts() {
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf
}

install_docker() {
    sudo apt-get update
    sudo apt-get install \
        linux-image-extra-$(uname -r) \
        linux-image-extra-virtual

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"

    sudo apt-get update
    sudo apt-get install docker-ce

    getent group docker || sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
}

install_docker_compose() {
    sudo curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
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
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim
}

install_erlang_and_elixir() {
    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
    sudo dpkg -i erlang-solutions_1.0_all.deb

    sudo apt-get update
    sudo apt-get install esl-erlang

    sudo apt-get install elixir
}

install_asdf() {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

    asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
	asdf install ruby 2.4.1
	asdf global ruby 2.4.1
}

install_dotfiles() {
    local DOTDIR="~/Works/dotfiles"
    echo "Clono dotfiles"

    echo "Configuro alias"
    cat ${DOTDIR}/aliases >> ~/.zshrc

    echo "Configuro tmux"
    cp ${DOTDIR}/tmux.conf ~/.tmux

    echo "Configuro i3"
    mkdir ~/.i3
    cp ${DOTDIR}/i3-config ~/.i3/config

    echo "Configuro ctags"
    cp ${DOTDIR}/ctags ~/.ctags

    echo "Configuro git"
    cp ${DOTDIR}/git/gitconfig ~/.gitconfig
    cp ${DOTDIR}/git/gitignore_global ~/.gitignore_global

    echo "Configuro vim"
    cp ${DOTDIR}/vim/init.vim ~/.config/nvim
    cp ${DOTDIR}/vim/local_init.vim ~/.config/nvim
    cp ${DOTDIR}/vim/local_bundles.vim ~/.config/nvim
    vim +PlugInstall +qall
}

generate_ssh() {
    ssh-keygen -t rsa -b 4096 -C "aleinside@gmail.com" -P "" -f $HOME/.ssh/id_rsa -q
}

install_vnc_server() {
    sudo apt-get install tightvncserver
    mkdir -p ~/.vnc
    cp ~/Works/dotfiles/xstartup ~/.vnc/xstartup
    sudo chmod +x ~/.vnc/xstartup
    echo "Ora puoi lanciare vncserver"
}

echo "Installo i pacchetti"
install_packages

echo "Installo oh my zsh"
install_oh_my_zsh

echo "Installo universal ctags"
install_universal_ctags

echo "Installo zfz"
install_fzf

echo "Installo nerd fonts"
install_nerd_fonts

echo "Installo neovim"
install_neovim

echo "Installo docker"
install_docker

echo "Installo docker compose"
install_docker_compose

echo "Installo e configuro asdf"
install_asdf

echo "Installo google chrome"
install_google_chrome

echo "Installo erlang"
install_erlang_and_elixir

echo "Configuratione dotfiles"
install_dotfiles

echo "Genero ssh"
generate_ssh

#echo "Install vnc server"
#install_vnc_server
