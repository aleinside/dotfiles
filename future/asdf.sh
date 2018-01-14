#!/bin/bash

asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 2.5.0
asdf global ruby 2.5.0

asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 20.2.2
asdf global erlang 20.2.2
 
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf intsall elixir 1.5.3
asdf global elixir 1.5.3

asdf plugin-add elm https://github.com/vic/asdf-elm.git
asdf install elm 0.18.0
asdf global elm 0.18.0

bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 9.4.0
asdf global nodejs 9.4.0

asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
asdf install python 3.6.4
asdf global python 3.6.4

pip install flake8 jedi neovim
pip install --user --upgrade neovim
    
npm install -g elm-format@exp
