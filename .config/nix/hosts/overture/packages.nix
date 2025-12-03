{ pkgs, ... }:
with pkgs; [
  neovim
  fd
  ripgrep
  fishPlugins.bass
  fishPlugins.tide

  sops
  age

  squid

  gh
  ghq
  jq
  lnav
  deno
  nodejs

  tree-sitter
  nixd
  nixpkgs-fmt
  vim-language-server
]
