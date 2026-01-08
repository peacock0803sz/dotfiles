{ pkgs, ... }:
with pkgs; [
  neovim
  tree-sitter

  fishPlugins.bass
  fishPlugins.tide
  direnv

  eza
  delta
  fd
  gh
  ghq
  jq
  lnav
  ripgrep

  deno
  nodejs

  yt-dlp
  ffmpeg
  imagemagick

  nixd
  nixpkgs-fmt
]
