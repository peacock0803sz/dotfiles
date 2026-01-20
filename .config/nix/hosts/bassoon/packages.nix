{ pkgs, ... }:
with pkgs; [
  fishPlugins.bass
  fishPlugins.tide
  direnv

  gh
  ghq
  jq
  lnav
  lemonade
  deno

  yt-dlp
  ffmpeg
  imagemagick
]
