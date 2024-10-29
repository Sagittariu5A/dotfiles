#!/bin/bash


SYS_ARCH=''

# Store Script Name to use later
[[ $0 =~ './' ]] && PROGRAM_NAME=$0 || PROGRAM_NAME="bash $0"

FONT_PATH_TO_SAVE_LOCAL="$HOME/.local/share/fonts"
FONT_PATH_TO_SAVE_GLOBAL='/usr/local/share/fonts'
DEFAULT_FONT_NAME='Hack'

LOCAL_BIN_DIR="${HOME}/.local/bin"
GLOBAL_BIN_DIR='/usr/local/bin'

TO_INSTALL=('fzf' 'font')
# Pre-Requisites as Map (command -> package)
declare -A PRE_REQUISITES=(
    ['curl']='curl'
    ['git']='git'
    ['unzip']='unzip'
    ['tar']='tar'
    ['fc-cache']='fontconfig'
)



# Util Functions implementation

_error() { printf "\e[31m$1\e[0m\n"; exit 1; }

_warn() { printf "⚠️  \e[33m$1\e[0m\n"; }

_info() { printf "$1\n"; }

# This function sets SYS_ARCH variable depends on 'umane -sm' command
_set_sys_arch() {
    local output=$(uname -sm)
    case $output in
        *'Linux x86_64'*)    SYS_ARCH='linux_amd64'    ;;
        *'Linux i386'*)      SYS_ARCH='linux_i386'     ;;
        *'Darwin x86_64'*)   SYS_ARCH='darwin_amd64'   ;;
        *'Darwin arm64'*)    SYS_ARCH='darwin_arm64'   ;;
        *)                     _error "Error: Unknown System Architecture '$output'" ;;
    esac
}

_set_sys_arch # Call the function to set SYS_ARCH

