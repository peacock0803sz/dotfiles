{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".config/alacritty".source = mkOutOfStoreSymlink ~/dotfiles/.config/alacritty;
    ".config/wezterm".source = mkOutOfStoreSymlink ~/dotfiles/.config/wezterm;
    ".config/rio/config.toml".source = mkOutOfStoreSymlink ~/dotfiles/.config/rio/config.toml;
    ".config/rio/themes/catppuccin-latte.toml".source = pkgs.fetchgit {
      url = "https://github.com/catppuccin/rio";
      sparseCheckout = [ "themes/catppuccin-latte.toml" ];
      hash = "sha256-EHv3e4QprL82arOBpa/81viXzEKmYjp+IK/9J+T0VL4=";
    };
  };
}
