export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git sudo zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

alias l=ls
alias ls="lsd -al"
