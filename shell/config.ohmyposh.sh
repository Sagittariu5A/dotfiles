#!/bin/bash

# Pre-requisites
PRE_REQUISITES['curl']='curl'


# install and setup ohmyposh
# this function takes bin dir to save on (default: local bin dir)
_setup_ohmyposh() {
  local bin_dir=${1:-$BIN_DIR}
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$bin_dir"
}

