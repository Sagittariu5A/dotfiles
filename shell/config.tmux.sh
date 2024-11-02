#!/bin/bash

# Include Utils
source ./utils.sh

# Set PRE_REQUISITES
PRE_REQUISITES['curl'] = 'curl'

# Function to Download TMUX ether MacOS or Linux
_setup_tmux () {
  local url = ''
  if [ $SYS_ARCH == 'linux_amd64' ]; then # Linux
    _error "Not Implemented yet"
  elif [ $SYS_ARCH == 'darwin_amd64' ]; then # MacOS
    _error "Unsupported System Architecture (MacOS amd64) try to find a way to install manually. We Apologize!"
  else
    _error "Unsupported System Architecture: $SYS_ARCH ($(uname -sm)), Maybe Soon."
  fi
}

