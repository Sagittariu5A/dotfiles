#!/bin/bash


# Store Script Name to use later
[[ $0 =~ './' ]] && PROGRAM_NAME=$0 || PROGRAM_NAME="bash $0"


SYS_ARCH=''
# This function sets SYS_ARCH variable depends on 'umane -sm' command
_set_sys_arch() {
    local output=$(uname -sm)
    case $output in
        *'Linux x86_64'*)    SYS_ARCH='linux_amd64' ;;
        *'Darwin x86_64'*)   SYS_ARCH='darwin_amd64' ;;
        *'Linux i386'*)      _error "Unsupported Linux amd-x86 32-bit" ;;
        *'Darwin arm64'*)    _error "We are working on MacOS arm64, comming Soon!" ;;
        *)                   _error "Error: Unknown System Architecture '$output'" ;;
        # *'Linux i386'*)      SYS_ARCH='linux_i386' ;;
        # *'Darwin arm64'*)    SYS_ARCH='darwin_arm64' ;;
    esac
}
_set_sys_arch # Call the function to set SYS_ARCH


LOCAL_BIN_DIR="${HOME}/.local/bin"
GLOBAL_BIN_DIR='/usr/local/bin'
BIN_DIR="${BIN_DIR:-$LOCAL_BIN_DIR}"


# Util Functions implementation
_error() { printf "\e[31m$1\e[0m\n"; exit 1; }

_warn() { printf "⚠️  \e[33m$1\e[0m\n"; }

_info() { printf "$1\n"; }

_random_string () {
  printf '%04x%04x%05x%04x%04x' $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM))
}

