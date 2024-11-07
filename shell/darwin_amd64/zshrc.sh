#!/bin/bash

_setup_zshrc() {
  mv -f ~/.zshrc ~/.zshrc.bak
  ln -sfn "$(pwd)/HOME/zshrc" ~/.zshrc
  if [ $? -ne 0 ]; then
    mv -f ~/.zshrc.bak ~/.zshrc
    _error "zshrc: Erorr while backup and make symbolic link of 'zsh' config"
  fi
}
