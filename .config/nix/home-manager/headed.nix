{ config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".config/alacritty".source = mkOutOfStoreSymlink ~/dotfiles/.config/alacritty;
    ".config/wezterm".source = mkOutOfStoreSymlink ~/dotfiles/.config/wezterm;
  };
}
