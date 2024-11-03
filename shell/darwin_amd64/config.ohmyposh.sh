#!/bin/bash

# Pre-requisites
# PRE_REQUISITES['curl']='curl'
_set_prereq 'curl' 'curl'

# install and setup ohmyposh
_setup_ohmyposh() {
  mv -f ~/.config/ohmyposh ~/.config/ohmyposh.bak 2>/dev/null
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN_DIR" &&
    ln -sfn "$(pwd)/HOME/config/ohmyposh" ~/.config/ohmyposh 2>/dev/null
  if [ $? -ne 0 ]; then
    mv -f ~/.config/ohmyposh.bak ~/.config/ohmyposh 2>/dev/null
    _error "ohmyposh: Erorr while setuping 'ohmyposh'"
  fi

  _info "ohmyposh: Successfully instelled"
}
