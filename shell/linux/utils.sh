# Pre-Requisites as Map (command -> package)
declare -A PRE_REQUISITES=(
  ['curl']='curl'
  ['git']='git'
  ['unzip']='unzip'
  ['tar']='tar'
  # ['fc-cache']='fontconfig'
)
# Add to PRE_REQUISITES ($1: key, $2: value)
_set_prereq() { PRE_REQUISITES[$1]=$2; }

# $1: install font globally or locally (default: local)
# $2: font name (default: value of DEFAULT_FONT_NAME variable which defaults to "Hack")
_install_nerd_font() {
  local font_path
  local font_name="${2:-Hack}"
  local font_zip="${font_name}.zip"
  local font_exist="${font_name}.exist"
  local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_zip"
  local temp_dir
  local response_code

  # Determine the font installation path
  case $1 in
  'global') font_path='/usr/local/share/fonts' ;;
  *) font_path="$HOME/.local/share/fonts" ;;
  esac

  # Create font path if it doesn't exist
  mkdir -p "$font_path"

  # Check if the font is already installed
  if [[ -f "${font_path}/${font_exist}" ]]; then
    _info "Skipped: Setup font '$font_name', font already exists."
    return
  fi

  # Create a temporary directory for downloading and unzipping
  temp_dir=$(mktemp -d)

  # Download the font
  response_code=$(curl -s -f -L "$font_url" -o "$temp_dir/$font_zip" -w "%{http_code}")

  # If download was successful, unzip to the font path
  if [[ "$response_code" == '200' ]]; then
    unzip -n "$temp_dir/$font_zip" -d "$font_path" &&
      fc-cache -fv &&
      touch "${font_path}/${font_exist}" &&
      _info "Font '$font_name' installed successfully."
  else
    rm -rf "$temp_dir"
    _error "Error while downloading font '$font_name'. Check font name (case sensitive). curl response error '$response_code'"
  fi

  # Clean up temporary directory
  rm -rf "$temp_dir"
}

_install_fzf() {
  # Create a temporary directory
  local tmp_dir=$(mktemp -d)
  local url="https://github.com/junegunn/fzf/releases/latest/download/fzf-0.56.0-linux_amd64.tar.gz"

  # Download, extract, and clean up
  curl -s -f -L "$url" -o "$tmp_dir/fzf.tar.gz" &&
    tar xfz "$tmp_dir/fzf.tar.gz" -C "$tmp_dir" &&
    mv "$tmp_dir/fzf" "$BIN_DIR" &&
    rm -rf "$tmp_dir" &&
    _info "fzf version $latest_version installed."
}

__pre_requisites__help() {
  echo 'usage:'
  echo "  $PROGRAM_NAME $1 option"
  echo '  options:'
  echo '    h | help       : show this help banner'
  echo "    l | list       : list all Pre-Requisites and some other instructions"
  echo "    g | get        : get all Pre-Requisites to install on"
  echo '    i | install    : install pre-requisites (Comming Soon)'
  exit 0
}

_pre_requisites() {
  if [ $# -gt 2 ]; then __pre_requisites__help $1; fi
  case $2 in
  l | list)
    echo "Pre-Requisites (on linux): ${PRE_REQUISITES[@]}"
    echo "to install use: sudo apt install -y \$(bash $PROGRAM_NAME $1 get)"
    echo '                     ^^^'
    echo 'remember to use your package manager depends on you linux distro, debian: apt, arch: pacman, ...'
    exit 0
    ;;
  g | get) echo -n ${PRE_REQUISITES[@]} ;;
  *) __pre_requisites__help $1 ;;
  esac
}

# validate pre-requisites
_validate_pre_requisites() {
  for requis in ${!PRE_REQUISITES[@]}; do
    if ! command -v $requis >/dev/null; then
      _error "$requis is required to make setup. Please install '${PRE_REQUISITES[$requis]}' and try again.
      for more info use: $PROGRAM_NAME pre-req help"
    fi
  done
}
