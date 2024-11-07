#!/bin/bash

# Pre-requisites
# PRE_REQUISITES['curl']='curl'
_set_prereq 'curl' 'curl'

# install and setup ohmyposh
_setup_ohmyposh() {
  mv -f ~/.config/ohmyposh ~/.config/ohmyposh.bak
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN_DIR" &&
    ln -sfn "$(pwd)/HOME/config/ohmyposh" ~/.config/ohmyposh
  if [ $? -ne 0 ]; then
    mv -f ~/.config/ohmyposh.bak ~/.config/ohmyposh
    _error "ohmyposh: Erorr while setuping 'ohmyposh'"
  fi

  _info "ohmyposh: Successfully instelled"
}
