#!/bin/bash


# Pre-requisites
# PRE_REQUISITES['curl']='curl'
_set_prereq 'curl' 'curl'


# install and setup ohmyposh
_setup_ohmyposh() {
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN_DIR" && \
  mv -f ~/.config/ohmyposh ~/.config/ohmyposh.bak 2> /dev/null && \
  ln -sfn "$(pwd)/HOME/config/ohmyposh" ~/.config/ohmyposh 2> /dev/null
  [[ $? -ne 0 ]] && _error "ohmyposh: Erorr while setuping 'ohmyposh'"
  _info "ohmyposh: Successfully instelled"
}

