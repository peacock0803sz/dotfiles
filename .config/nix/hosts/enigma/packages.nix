{ pkgs, ... }:
with pkgs; [
  neovim

  fishPlugins.bass
  fishPlugins.tide
  direnv

  gh
  ghq
  jq
  lnav
  deno
  nodejs

  yt-dlp
  ffmpeg
  imagemagick

  nixd
]
