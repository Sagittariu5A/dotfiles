#!/bin/bash

# Store Script Name to use later
PROGRAM_NAME="$0"
FONT_PATH_TO_SAVE_LOCAL="$HOME/.local/share/fonts"
FONT_PATH_TO_SAVE_GLOBAL='/usr/local/share/fonts'
DEFAULT_FONT_NAME='Hack'
LOCAL_BIN_DIR="${HOME}/.local/bin"
GLOBAL_BIN_DIR='/usr/local/bin'
PRE_REQUISITES=('wget' 'git' 'unzip' 'tar' 'fontconfig')
TO_INSTALL=('fzf' 'font')


__help () {
  echo 'usage:'
  echo "  $PROGRAM_NAME command"
  echo '  commands:'
  echo '    h | help                       : show this help banner'
  echo '    i | install [OPTIONS]          : install a command/binary/font'
  echo '                                     use h/help as OPTION for more info'
  echo '    s | setup                      : copy dotfiles config files to system'
  echo '    b | back | backup              : copy system config files to dotfiles'
  echo '    p | pre | pre-req [OPTIONS]    : get or list all pre-requisites (on linux)'
  echo '                                     use h/help as OPTION for more info'
  exit 0
}


__pre_requisites__help () {
  echo 'usage:'
  echo "  $PROGRAM_NAME $1 option"
  echo '  options:'
  echo '    h | help       : show this help banner'
  echo "    l | list       : list all Pre-Requisites and some other instructions"
  echo "    g | get        : get all Pre-Requisites to install on"
  echo '    i | install    : install pre-requisites (Comming Soon)'
  exit 0
}

pre_requisites () {
  if [ $# -gt 2 ]; then __pre_requisites__help $1 ; fi
  case $2 in
    l | list)
      echo "Pre-Requisites (on linux): ${PRE_REQUISITES[@]}"
      echo "to install use: sudo apt install \$(bash $PROGRAM_NAME $1 get)"
      echo '                     ^^^'
      echo 'remember to use your package manager depends on you linux distro, debian: apt, arch: pacman, ...'
      exit 0
      ;;
    g | get)   echo ${PRE_REQUISITES[@]} ;;
    *)         __pre_requisites__help $1 ;; 
  esac
}


__install_nerd_font__help () {
  echo 'usage:'
  echo "  $PROGRAM_NAME install $1 option1 option2*"
  echo '  option1:'
  echo '    h | help             : show this help banner'
  echo "    l | local  option2*  : install font for current user only ($USER) in '$FONT_PATH_TO_SAVE_LOCAL'"
  echo "    g | global option2*  : install font for system in '$FONT_PATH_TO_SAVE_GLOBAL'"
  echo "  option2*               : (optional) nert font name (case sensitive), default '$DEFAULT_FONT_NAME'"
  exit 0
}

install_nerd_font () {
  if [ $# -gt 3 ]; then __install_nerd_font__help $1 ; fi
  case $2 in
    l | local)    FONT_PATH_TO_SAVE="$FONT_PATH_TO_SAVE_LOCAL" ;;
    g | global)   FONT_PATH_TO_SAVE="$FONT_PATH_TO_SAVE_GLOBAL" ;;
    *)            __install_nerd_font__help $1 ;; 
  esac
  # set Some Variables about Font Name
  FONT_NAME="${3:-${DEFAULT_FONT_NAME}}"
  FONT_ZIP="${FONT_NAME}.zip"
  FONT_EXIST="${FONT_NAME}.exist"
  # check font exist or not then download and unzip
  if [ ! -f "${FONT_PATH_TO_SAVE}/${FONT_EXIST}" ]; then
    if [ ! -f "${FONT_PATH_TO_SAVE}/${FONT_ZIP}" ]; then
      wget -P "$FONT_PATH_TO_SAVE" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/"$FONT_ZIP"
    else
      echo "Skipped: Download font '$FONT_NAME', $FONT_ZIP already exist."
    fi
    cd "$FONT_PATH_TO_SAVE" && unzip -n "$FONT_ZIP"  && rm -rf "$FONT_ZIP" && fc-cache -fv && touch "$FONT_EXIST"
  else
    echo "Skipped: Setup font '$FONT_NAME', Font already exist."
  fi
}


__install_fzf__help () {
  echo 'usage:'
  echo "  $PROGRAM_NAME install $1 option"
  echo '  option:'
  echo '    h | help   : show this help banner'
  echo "    l | local  : save $1 for current user only ($USER) in '$LOCAL_BIN_DIR'"
  echo "    g | global : save $1 for system in '$GLOBAL_BIN_DIR'"
  exit 0
}

install_fzf () {
  if [ $# -ne 2 ]; then __install_fzf__help $1 ; fi
  case $2 in
    g | global)     BIN_DIR="$GLOBAL_BIN_DIR" ;;
    l | local)      BIN_DIR="$LOCAL_BIN_DIR" ;;
    *)              __install_fzf__help $1 ;
  esac
  VER='0.55.0'
  SYS_ARCH='linux_amd64'
  FILE_NAME="fzf-${VER}-${SYS_ARCH}.tar.gz"
  if [ ! -f "${BIN_DIR}/$1" ]; then
    wget -P "$BIN_DIR" "https://github.com/junegunn/fzf/releases/download/v$VER/$FILE_NAME"
    cd "$BIN_DIR" && tar xfz "$FILE_NAME" && rm -rf "$FILE_NAME" && \
    echo && echo "Remember to add '$BIN_DIR' to PATH env." && \
    echo "use: export PATH=\"$BIN_DIR:\$PATH\""
  else
    echo "Skipped: Download $1 to bin folder '$BIN_DIR', $1 already exist on."
  fi
}


setup  () {
  echo 'make_setup funcions called'
}


backup () {
  echo 'make_backup funcions called'
}


__install__help () {
  echo 'usage:'
  echo "  $PROGRAM_NAME $1 option"
  echo '    option : is what to install'
  echo "             the availables: ${TO_INSTALL[@]}"
  exit 0
}

install () {
  if [ $# -lt 2 ]; then __install__help $1 ; fi
  case $2 in
    font)     install_nerd_font ${@:2} ;;
    fzf)      install_fzf ${@:2} ;;
    *)        __install__help $1 ;;
  esac
}



case "$1" in
  i | install)            install $@ ;;
  s | setup)              setup ;;
  b | back | bckup)       backup ;;
  p | pre | pre-req)      pre_requisites $@ ;;
  *)                      __help ;;
esac


