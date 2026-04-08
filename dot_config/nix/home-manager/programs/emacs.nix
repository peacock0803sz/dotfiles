{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  home.packages = with pkgs; [
    emacs
  ];

  home.file = {
    # ".emacs.d".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.emacs.d";
  };
}
