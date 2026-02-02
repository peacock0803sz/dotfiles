{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  home.packages = with pkgs; [
    bat
  ];

  home.file = {
    ".config/bat".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/bat";
  };
}
