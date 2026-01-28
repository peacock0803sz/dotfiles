{ pkgs, ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    ".config/wezterm".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/wezterm";
  };
  home.packages = if pkgs.stdenv.isDarwin then [ pkgs.brewCasks.wezterm ] else [ pkgs.wezterm ];
}
