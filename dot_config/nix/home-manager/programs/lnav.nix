{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  home.packages = with pkgs; [
    lnav
  ];

  home.file = {
    ".config/lnav/config.json".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/lnav/config.json";
  };
}
