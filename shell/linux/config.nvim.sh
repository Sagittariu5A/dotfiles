# Set PRE_REQUISITES
_set_prereq 'curl' 'curl'
_set_prereq 'tar' 'tar'

# Function to Download NVIM for either macOS or Linux
_setup_nvim() {
  local url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
  local tmp_dir="$(mktemp -d)"
  local tmp_out_dir="$tmp_dir/nvim-linux-x86_64"
  local dest_dir="$(dirname -z $BIN_DIR)"
  local src_dirs=("bin" "lib" "share")

  # Download NVIM
  if ! curl -s -f -L "$url" -o "$tmp_dir/nvim.tar.gz"; then
    rm -rf "$tmp_dir"
    _error "nvim: Download failed - check network or URL"
  fi

  # Extract the downloaded tarball
  if ! tar -xzf "$tmp_dir/nvim.tar.gz" -C "$tmp_dir"; then
    rm -rf "$tmp_dir"
    _error "nvim: Extraction failed - corrupt archive?"
  fi

  # --- Enhanced copy operation ---
  # Verify source directories exist
  for dir in "${src_dirs[@]}"; do
    if [[ ! -d "$tmp_out_dir/$dir" ]]; then
      rm -rf "$tmp_dir"
      _error "nvim: Missing extracted directory '$tmp_out_dir/$dir'"
    fi
  done

  # Verify destination permissions
  if [[ ! -d "$dest_dir" ]]; then
    rm -rf "$tmp_dir"
    _error "nvim: Destination '$dest_dir' does not exist"
  elif [[ ! -w "$dest_dir" ]]; then
    rm -rf "$tmp_dir"
    _error "nvim: No write permissions in '$dest_dir'"
  fi

  # Perform copy with error visibility
  if ! cp -fr "${src_dirs[@]/#/$tmp_out_dir/}" "$dest_dir"; then
    rm -rf "$tmp_dir"
    _error "nvim: Copy failed - check disk space or permissions"
  fi
  # --- End enhanced copy ---

  # Clean up temporary directory
  rm -rf "$tmp_dir"

  # Enhanced symlink handling
  local nvim_config_src="$(pwd)/HOME/config/nvim"
  local nvim_config_dest="$HOME/.config/nvim"

  # Verify source config exists
  if [[ ! -d "$nvim_config_src" ]]; then
    _error "nvim: Config source '$nvim_config_src' not found"
    return 1
  fi

  # Create backup only if config exists
  if [[ -d "$nvim_config_dest" ]]; then
    mv -f "$nvim_config_dest" "${nvim_config_dest}.bak" || {
      _error "nvim: Failed to create backup"
      return 1
    }
  fi

  # Create symlink with validation
  if ln -sfn "$nvim_config_src" "$nvim_config_dest"; then
    _info "Created nvim config symlink: $nvim_config_dest → $nvim_config_src"
  else
    [[ -d "${nvim_config_dest}.bak" ]] && mv -f "${nvim_config_dest}.bak" "$nvim_config_dest"
    _error "nvim: Symlink creation failed - check permissions"
  fi

  _info "nvim: Installation completed successfully"
}
