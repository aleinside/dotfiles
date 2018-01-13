#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# avoid interactive installation
export DEBIAN_FRONTEND=noninteractive

install_oh_my_zsh() {
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    chsh -s /bin/zsh
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
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
}

install_asdf() {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
}

install_dotfiles() {
    local DOTDIR="~/Works/dotfiles"

    cat ${DOTDIR}/aliases >> ~/.zshrc

    cp ${DOTDIR}/tmux.conf ~/.tmux

    cp ${DOTDIR}/ctags ~/.ctags

    cp ${DOTDIR}/git/gitconfig ~/.gitconfig
    cp ${DOTDIR}/git/gitignore_global ~/.gitignore_global

    cp ${DOTDIR}/vim/wp-init.vim ~/.config/nvim/init.vim
    
    cp ${DOTDIR}/default-gems ~/.default-gems
}

install_packages() {
    sudo apt-get install -y htop zsh tree tig tmux jq silversearcher-ag dh-autoreconf
}

install_languages() {
    asdf plugin-add ruby
    asdf install ruby 2.5.0
    asdf global ruby 2.5.0

    asdf plugin-add erlang
    asdf install erlang 20.2.2
    asdf global erlang 20.2.2
 
    asdf plugin-add elixir
    asdf intsall elixir 1.5.3
    asdf global elixir 1.5.3

    asdf plugin-add elm
    asdf install elm 0.18.0
    asdf global elm 0.18.0

    bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
    asdf plugin-add nodejs
    asdf install nodejs 9.4.0
    asdf global nodejs 9.4.0

    asdf plugin-add python
    asdf install python 3.6.4
    asdf global python 3.6.4

    pip install flake8 jedi neovim
    pip install --user --upgrade neovim
    
    npm install -g elm-format@exp
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
install_languages
