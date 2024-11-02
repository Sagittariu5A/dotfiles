#!/bin/bash


# Set PRE_REQUISITES
PRE_REQUISITES['curl'] = 'curl'

# Function to Download TMUX or Linux
_setup_tmux () {
  if command -v tmux > /dev/null; then
    mv -f ~/.config/tmux ~/.config/tmux.bak 2> /dev/null
    ln -sfn "$(pwd)/HOME/config/tmux" ~/.config/tmux 2> /dev/null
    [[ $? -ne 0 ]] && _error "tmux: Erorr while backup and make symbolic link of 'tmux' config"
  else
    _error "tmux: command not found try to install manually then retry."
  fi
}

