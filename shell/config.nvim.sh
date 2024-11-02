#!/bin/bash

# Include Utils
source ./utils.sh

# Set PRE_REQUISITES
PRE_REQUISITES['curl'] = 'curl'
PRE_REQUISITES['tar']  = 'tar'

# Function to Download TMUX ether MacOS or Linux
_setup_nvim () {
  if [ -z $BIN_DIR ]; then _error "BIN_DIR env is unset, is necessary to look where nvim to be installed"; fi

  local url=''
  local name=''
  local bin_dir="${1:-$BIN_DIR}"
  local tmp_dir="/tmp/neovim-release-$(printf '%04x%04x%04x%04x%04x' $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM)) )"

  if [ $SYS_ARCH == 'linux_amd64' ]; then # Linux
    name='nvim-linux64'
    url="https://github.com/neovim/neovim/releases/latest/download/${name}.tar.gz"
  elif [ $SYS_ARCH == 'darwin_amd64' ]; then # MacOS
    name='nvim-macos-x86_64'
    url="https://github.com/neovim/neovim/releases/latest/download/${name}.tar.gz"
  else
    _error "Unsupported System Architecture: $SYS_ARCH ($(uname -sm)), Maybe Soon."
  fi

  mkdir -p $tmp_dir && cd $tmp_dir && curl -s -f -L $url -o nvim.tar.gz && tar xfz nvim.tar.gz && \
  mv -f "${name}/bin" "${name}/lib" "${name}/share" "${bin_dir}/../" && rm -rf $tmp_dir && \
  ln -s "$(pwd)/HOME/config/nvim" ~/.config/nvim
  if [ $? -ne 0 ]; then _error "nvim: Error while setuping 'nvim'"; fi
}

