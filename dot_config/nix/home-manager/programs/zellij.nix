{ pkgs, ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    ".config/zellij".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/zellij";
  };
  home.packages = with pkgs; [ zellij ];
}
