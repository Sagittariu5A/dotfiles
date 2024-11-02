#!/bin/bash


# Set PRE_REQUISITES
# PRE_REQUISITES['curl'] = 'curl'
# PRE_REQUISITES['tar']  = 'tar'
_set_prereq 'curl' 'curl'
_set_prereq 'curl' 'curl'

# Function to Download NVIM for either macOS or Linux
_setup_nvim () {
  local url="https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz"
  local tmp_dir="$(mktemp -d)"
  local tmp_out_dir="$tmp_dir/nvim-macos-x86_64"

  # Download NVIM
  if ! curl -s -f -L "$url" -o "$tmp_dir/nvim.tar.gz"; then
    rm -rf "$tmp_dir"
    _error "nvim: Error downloading"
  fi

  # Extract the downloaded tarball
  if ! tar -xzf "$tmp_dir/nvim.tar.gz" -C "$tmp_dir"; then
    rm -rf "$tmp_dir"
    _error "nvim: Error extracting 'nvim.tar.gz'"
  fi

  # Move the extracted directories to the bin_dir
  if ! mv -f "$tmp_out_dir/bin" "$tmp_out_dir/lib" "$tmp_out_dir/share" "$BIN_DIR/../" 2> /dev/null; then
    rm -rf "$tmp_dir"
    _error "nvim: Error moving extracted files to $BIN_DIR/../"
  }

  # Clean up temporary directory
  rm -rf "$tmp_dir"

  # Create a symbolic link for nvim configuration
  mv -f ~/.config/nvim  ~/.config/nvim.bak 2> /dev/null && \
  ln -sfn "$(pwd)/HOME/config/nvim" ~/.config/nvim 2> /dev/null
  [[ $? -ne 0 ]] && _error "nvim: Error while making buckup or creating symlink for nvim configuration"

  _info "nvim installed successfully."
}

