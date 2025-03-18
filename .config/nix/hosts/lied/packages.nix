{ pkgs, ... }:
with pkgs; [
  neovim

  eza
  delta
  fd
  fish
  fishPlugins.bass
  fishPlugins.tide
  gojq
  gh
  jq
  ripgrep
  wget

  bun
  deno
]
