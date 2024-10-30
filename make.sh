#!/bin/bash

# Start Source Scripts
source shell/utils.sh # shall Loaded First
source shell/config.ohmyposh.sh

# validate pre-requisites
_validate_pre_requisites() {
    for requis in ${!PRE_REQUISITES[@]}; do
        if ! command -v $requis > /dev/null; then
            _error "$requis is required to make setup. Please install '${PRE_REQUISITES[$requis]}' and try again.
            for more info use: $PROGRAM_NAME pre-req help"
        fi
    done
}


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

_pre_requisites () {
    if [ $# -gt 2 ]; then __pre_requisites__help $1 ; fi
    case $2 in
        l | list)
            echo "Pre-Requisites (on linux): ${PRE_REQUISITES[@]}"
            echo "to install use: sudo apt install -y \$(bash $PROGRAM_NAME $1 get)"
            echo '                     ^^^'
            echo 'remember to use your package manager depends on you linux distro, debian: apt, arch: pacman, ...'
            exit 0
            ;;
        g | get)   echo ${PRE_REQUISITES[@]} ;;
        *)         __pre_requisites__help $1 ;;
    esac
}


_setup  () {
    _error 'NotImplementedError: setup not implemented yet'
}


_backup () {
    _error 'NotImplementedError: backup not implemented yet'
}


__install__help () {
    echo 'usage:'
    echo "  $PROGRAM_NAME $1 option"
    echo '    option : is what to install'
    echo "             the availables: ${TO_INSTALL[@]}"
    exit 0
}

_install () {
    _set_sys_arch
    _validate_pre_requisites

    if [ $# -lt 2 ]; then __install__help $1 ; fi
    case $2 in
        font)     _install_nerd_font ${@:2} ;;
        fzf)      _install_fzf ${@:2} ;;
        *)        __install__help $1 ;;
    esac
}


main__make_sh() {
    case $1 in
        i | install)            _install $@ ;;
          s | setup)              _setup ;;
        b | back | bckup)       _backup ;;
        p | pre | pre-req)      _pre_requisites $@ ;;
        *)                      __help ;;
    esac
}


(return 0 2> /dev/null) || main__make_sh $@


