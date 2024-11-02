#!/bin/bash


# Pre-requisites
PRE_REQUISITES['curl']='curl'


# install and setup ohmyposh
_setup_ohmyposh() {
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN_DIR" && \
  mv ~/.config/ohmyposh ~/.config/ohmyposh.bak && \
  ln -sfn "$(pwd)/HOME/config/ohmyposh" ~/.config/ohmyposh
  [[ $? -ne 0 ]] && _error "ohmyposh: Erorr while setuping 'ohmyposh'"
  _info "ohmyposh: Successfully instelled"
}

