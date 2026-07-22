#!/bin/bash

mkdir ~/dev
mkdir ~/dev/work
mkdir ~/dev/personal

cd $HOME/.dotfiles
stow . --adopt
git reset --hard
