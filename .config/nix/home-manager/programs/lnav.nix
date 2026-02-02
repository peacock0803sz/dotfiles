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
    ".config/lnav".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/lnav";
  };
}
