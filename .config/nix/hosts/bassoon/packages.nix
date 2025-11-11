{ pkgs, ... }:
with pkgs; [
  neovim
  fd
  ripgrep

  gh
  deno
  nodejs
  nixd
  nixpkgs-fmt
  vim-language-server
]
