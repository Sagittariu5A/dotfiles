#!/bin/bash


# set local bin dir for ohmyposh
OHMYPOSH_LOCAL_BIN_DIR="${LOCAL_BIN_DIR:-${HOME}/.local/bin}"

# Pre-requisites
PRE_REQUISITES['curl']='curl'


setup_ohmyposh() {
  BIN_DIR="${1:-$OHMYPOSH_LOCAL_BIN_DIR}"
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN_DIR"
}


