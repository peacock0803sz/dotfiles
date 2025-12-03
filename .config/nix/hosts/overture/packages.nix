{ pkgs, ... }:
with pkgs; [
  neovim
  fd
  ripgrep
  fishPlugins.bass
  fishPlugins.tide

  squid

  gh
  ghq
  jq
  lnav
  deno
  nodejs

  nixd
  nixpkgs-fmt
  vim-language-server
]
