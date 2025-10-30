{ pkgs, ... }:
with pkgs; [
  neovim

  gh
  nodejs
  nixd
  nixpkgs-fmt
  vim-language-server
]
