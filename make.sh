#!/bin/bash

# Store Script Name to use later
SYS_ARCH=''

# set Program Name
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



# Start functions implementation

_error() { printf "\e[31m$1\e[0m\n"; exit 1; }

_warn() { printf "⚠️  \e[33m$1\e[0m\n"; }

_info() { printf "$1\n"; }


# this function sets SYS_ARCH variable depends on 'umane -sm' command
_set_sys_arch() {
    local output=$(uname -sm)
    case $output in
        *'Linux x86_64'*)    SYS_ARCH='linux_amd64'    ;;
        *'Linux i386'*)      SYS_ARCH='linux_i386'     ;;
        *'Darwin x86_64'*)   SYS_ARCH='darwin_amd64'   ;;
        *'Darwin arm64'*)    SYS_ARCH='darwin_arm64'   ;;
        *)                     _error "Error: Unknown System '$output'" ;;
    esac
}


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

_install_nerd_font () {
    local font_path=''
    local font_name="${3:-${DEFAULT_FONT_NAME}}"
    local font_zip="${font_name}.zip"
    local font_exist="${font_name}.exist"
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/latest/$font_zip"
    local response_code='200'

    if [ $# -gt 3 ]; then __install_nerd_font__help $1 ; fi
    case $2 in
        l | local)     font_path=$FONT_PATH_TO_SAVE_LOCAL ;;
        g | global)    font_path=$FONT_PATH_TO_SAVE_GLOBAL ;;
        *)             __install_nerd_font__help $1 ;;
    esac
    # check font exist or not then download and unzip
    if [ ! -f "${font_path}/${font_exist}" ]; then
        if [ ! -f "${font_path}/${font_zip}" ]; then
            response_code=$(curl -s -f -L "$font_url" -o "$font_path/$font_zip" -w "%{http_code}")
        fi
        if [ $response_code == '200' ]; then
            cd "$font_path" && unzip -n "$font_zip"  && rm -rf "$font_path" && fc-cache -fv && touch "$font_exist"
        else
            rm -rf "${font_path}/${font_zip}"
            _error "Error while downloading font '$font_name', double check font name (case sensitive),\ncurl response error '$response_error'"
        fi
    else
        _info "Skipped: Setup font '$font_name', Font already exist."
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

_install_fzf () {
    local bin_dir=''
    local ver='0.55.0'
    local name="fzf-${ver}-${SYS_ARCH}.tar.gz"
    local url="https://github.com/junegunn/fzf/releases/download/v$ver/$name"
    local response_code='200'
    
    if [ $# -ne 2 ]; then __install_fzf__help $1 ; fi
    case $2 in
        g | global)        bin_dir=$GLOBAL_BIN_DIR ;;
        l | local)        bin_dir=$LOCAL_BIN_DIR ;;
        *)                __install_fzf__help $1 ;
    esac

    if [ ! -f "${bin_dir}/$1" ]; then
        response_code=$(curl -s -f -L "$url" -o "$bin_dir/$name" -w '%{http_code}')
        if [ $? == 0 ]; then
            cd "$bin_dir" && tar xfz "$name" && rm -rf "$name" && \
            [[ ! $PATH =~ $bin_dir ]] && \
            _warn "'$bin_dir' didn't in PATH, Please remember to add it." && \
            _info "use: export PATH=\"$bin_dir:\$PATH\""
        elif [ $response_code == '200' ]; then
            _error "File Write Error: curl fail writing '$name' to '$bin_dir'"
        else
            _error "Invalid URL Error: curl (http_code: $response_code) fail with to download '$name' from '$url'"
        fi
    else
        _info "Skipped: Download $1 to bin folder '$bin_dir', $1 already exist on."
    fi
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







