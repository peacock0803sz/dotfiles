{ pkgs, ... }:
with pkgs; [
  fishPlugins.bass
  fishPlugins.tide
  direnv

  gh
  ghq
  jq
  lnav
  deno
]
