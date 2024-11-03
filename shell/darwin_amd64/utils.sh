#!/bin/bash

# <<<<< Work Until Bash v4 >>>>>>>>>>
# Pre-Requisites as Map (command -> package)
# declare -A PRE_REQUISITES=(
#   ['curl']='curl'
#   ['git']='git'
#   ['unzip']='unzip'
#   ['tar']='tar'
# )

# So we do other methode to hundle associated array (map key->value)
__prereq_keys=()
__prereq_values=()

# Function to set a prerequisite
_set_prereq() {
  local key="$1"
  local value="$2"
  local index=0

  # Check if key already exists
  for existing_key in "${__prereq_keys[@]}"; do
    if [ "$existing_key" = "$key" ]; then
      # Update existing value
      __prereq_values[$index]="$value"
      return
    fi
    ((index++))
  done

  # Add new key-value pair
  __prereq_keys+=("$key")
  __prereq_values+=("$value")
}

# Function to get a prerequisite value by key
_get_prereq() {
  local key="$1"
  local index=0

  for existing_key in "${__prereq_keys[@]}"; do
    if [ "$existing_key" = "$key" ]; then
      echo "${__prereq_values[$index]}"
      return
    fi
    ((index++))
  done
  return 1 # Key not found
}

# Function to list all prerequisites
_list_prereq() {
  local index=0
  for key in "${__prereq_keys[@]}"; do
    echo "$key=${__prereq_values[$index]}"
    ((index++))
  done
}

# Function to list all prerequisites keys
_list_prereq_keys() { echo -n $__prereq_keys; }

# Function to list all prerequisites values
_list_prereq_values() { echo -n $__prereq_values; }
# <<<<<<<< END of Temporary Solution >>>>>>>>>>>>>>>>

_set_prereq 'curl' 'curl'
_set_prereq 'git' 'git'
_set_prereq 'unzip' 'unzip'
_set_prereq 'tar' 'tar'

# $1: install font globally or locally (default: local)
# $2: font name (default: Hack)
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
  'global') font_path='/Library/Fonts' ;;
  *) font_path="$HOME/Library/Fonts" ;;
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

_setup_fzf() {
  local tmp_dir url latest_version

  # Create a temporary directory
  tmp_dir=$(mktemp -d)

  # Fetch the latest release URL and version number
  url=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest |
    grep -oP '(?<=browser_download_url": ")[^"]*fzf-[0-9.]+-darwin_amd64\.tar\.gz')
  latest_version=$(echo "$url" | grep -oP 'fzf-[0-9.]+' | head -1)

  # Download, extract, and clean up
  curl -s -f -L "$url" -o "$tmp_dir/${latest_version}.tar.gz" &&
    tar -xfz "$tmp_dir/${latest_version}.tar.gz" -C "$tmp_dir" &&
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
    echo "Pre-Requisites (on MacOS): ${__prereq_keys[@]}"
    echo "to install use: sudo brew install \$(bash $PROGRAM_NAME $1 get)"
    exit 0
    ;;
  g | get) _list_prereq_values ;;
  *) __pre_requisites__help $1 ;;
  esac
}

# validate pre-requisites
_validate_pre_requisites() {
  local index=0
  for requis in "${__prereq_keys[@]}"; do
    if ! command -v $requis >/dev/null; then
      _error "$requis is required to make setup. Please install '${__prereq_values[$index]}' and try again.
      for more info use: $PROGRAM_NAME pre-req help"
    fi
    ((index++))
  done
}
