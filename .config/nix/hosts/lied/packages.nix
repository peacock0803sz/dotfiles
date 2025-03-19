{ pkgs, ... }:
with pkgs; [
  neovim

  eza
  delta
  fd
  fish
  fishPlugins.bass
  fishPlugins.tide
  fzf
  gojq
  gh
  jq
  ripgrep
  wget

  bun
  deno
  nodejs

  lua-language-server
  nixd
  nixpkgs-fmt
]
