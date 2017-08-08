#!/bin/bash

echo "Copy init.vim"
cp init.vim ~/.config/nvim

echo "Copy local_init"
cp local_init.vim ~/.config/nvim

echo "Copy local_bundles"
cp local_bundles.vim ~/.config/nvim

echo "Install plugins"
vim +PlugInstall +qall
