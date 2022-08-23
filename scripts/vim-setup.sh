#!/usr/bin/env sh

# Setup `onedark.vim` theme
mkdir -p "$HOME"/.vim/pack/plugins/opt
git clone https://github.com/joshdick/onedark.vim.git \
  "$HOME"/.vim/pack/plugins/opt/onedark.vim
