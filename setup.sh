#!/bin/bash

DOT_FILES=( .zsh .zshrc .vimrc .tmux.conf .zshenv)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done
