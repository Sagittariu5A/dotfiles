#!/bin/bash

# Pre-requisites
# PRE_REQUISITES['curl']='curl'
# _set_prereq 'curl' 'curl'

# Function to Download TMUX or MasOS
_setup_tmux() {
  if command -v tmux >/dev/null; then
    mv -f ~/.config/tmux ~/.config/tmux.bak
    ln -sfn "$(pwd)/HOME/config/tmux" ~/.config/tmux
    if [ $? -ne 0 ]; then
      mv -f ~/.config/tmux.bak ~/.config/tmux
      _error "tmux: Erorr while backup and make symbolic link of 'tmux' config"
    fi
  else
    _error "tmux: command not found try to install manually then retry."
  fi
}
