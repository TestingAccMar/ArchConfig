#!/bin/bash

# Coding stuff.
sudo pamac install neovim ripgrep neovide xclip nvim-packer-git --no-confirm
sudo pamac install nodejs code --no-confirm

# Programming.
sudo pamac install julia-bin emf-langserver cmake python go --no-confirm


# Install language servers.
sudo chmod +x ~/.config/nvim/lua/alex/lang/lsp/install-servers.sh
