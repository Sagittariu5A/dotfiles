#!/bin/bash

# Start Source Scripts
source shell/utils.sh # Shall loaded first
source "shell/${SYS_ARCH}/init.sh"

__help() {
  echo 'usage:'
  echo "  $PROGRAM_NAME command"
  echo '  commands:'
  echo '    h | help                       : show this help banner'
  echo '    i | install [OPTIONS]          : install a command/binary/font'
  echo '                                     use h/help as OPTION for more info'
  echo '    s | setup                      : setup necessary dependencies and make symbolic link of dotfiles config files to config files'
  echo '    b | back | backup              : copy system config files to dotfiles'
  echo '    p | pre | pre-req [OPTIONS]    : get or list all pre-requisites (on linux)'
  echo '                                     use h/help as OPTION for more info'
  exit 0
}

_setup() {
  _validate_pre_requisites
  for setup in $@; do
    _info "Setuping '$setup' ....."
    case $setup in
    nvim) _setup_nvim ;;
    tmux) _setup_tmux ;;
    ohmyposh) _setup_ohmyposh ;;
    *) _warn "Unknown Setup '$setup'" ;;
    esac
  done
}

_backup() {
  _error 'NotImplementedError: backup not implemented yet.
  use: git add . && git commit -m "message" && git push origin master'
}

__install__help() {
  echo 'usage:'
  echo "  $PROGRAM_NAME $1 option"
  echo '    option : is what to install'
  echo "             the availables: fzf font"
  exit 0
}

_install() {
  if [ $# -lt 2 ]; then __install__help $1; fi
  _validate_pre_requisites
  case $2 in
  font) _install_nerd_font ${@:2} ;;
  fzf) _install_fzf ;;
  *) __install__help $1 ;;
  esac
}

main__make_sh() {
  case $1 in
  i | install) _install $@ ;;
  s | setup) _setup ${@:2} ;;
  b | back | bckup) _backup ;;
  p | pre | pre-req) _pre_requisites $@ ;;
  *) __help ;;
  esac
}

(return 0 2>/dev/null) || main__make_sh $@
