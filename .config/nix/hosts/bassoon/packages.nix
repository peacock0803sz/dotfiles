{ pkgs, ... }:
with pkgs; [
  fishPlugins.bass
  fishPlugins.tide

  gh
  ghq
  jq
  lnav
  deno

  yt-dlp
  ffmpeg
  imagemagick
]
