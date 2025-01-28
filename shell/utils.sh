# Store Script Name to use later
[[ $0 =~ './' ]] && PROGRAM_NAME=$0 || PROGRAM_NAME="bash $0"

LOCAL_BIN_DIR="${HOME}/.local/bin"
GLOBAL_BIN_DIR='/usr/local/bin'
BIN_DIR="${BIN_DIR:-$LOCAL_BIN_DIR}"

# Util Functions implementation
_error() {
  printf "\e[31m$1\e[0m\n"
  exit 1
}

_warn() { printf "⚠️  \e[33m$1\e[0m\n"; }

_info() { printf "$1\n"; }

_random_string() {
  printf '%04x%04x%05x%04x%04x' $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM))
}

SYS_ARCH=''

# This function sets SYS_ARCH variable based on the 'uname -sm' command
_set_sys_arch() {
  local output=$(uname -sm)

  case $output in
  *'Linux x86_64'*) SYS_ARCH='linux_amd64' ;;

  *'Linux i386'*) SYS_ARCH='linux_i386' ;;
  *'Linux i686'*) SYS_ARCH='linux_i386' ;;

  *'Linux armv7l'*) SYS_ARCH='linux_armv7' ;;
  *'Linux aarch64'*) SYS_ARCH='linux_arm64' ;;

  *'Darwin x86_64'*) SYS_ARCH='darwin_amd64' ;;

  *'Darwin arm64'*) SYS_ARCH='darwin_arm64' ;;

  *'Linux Microsoft'* | *'Linux WSL'*) SYS_ARCH='windows_wsl' ;;

  *'FreeBSD x86_64'*) SYS_ARCH='freebsd_amd64' ;;
  *'FreeBSD i386'*) SYS_ARCH='freebsd_i386' ;;

  *'Linux'*) _error "Unsupported Linux architecture: '$output'" ;;
  *'Darwin'*) _error "Unsupported macOS architecture: '$output'" ;;
  *'FreeBSD'*) _error "Unsupported FreeBSD architecture: '$output'" ;;

  *) _error "Error: Unknown System Architecture '$output'" ;;
  esac
}

# Call the function to set SYS_ARCH
_set_sys_arch
