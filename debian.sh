#!/bin/sh

sudo apt-get install zsh tmux vim rake git ncurses-bin
chsh -s $(which zsh)
tic xterm-screen-256color.terminfo
rake

