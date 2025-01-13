{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".config/alacritty".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/alacritty";
    ".config/wezterm".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/wezterm";
    ".config/rio/config.toml".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/rio/config.toml";
    ".config/rio/themes".source = (pkgs.fetchgit {
      url = "https://github.com/catppuccin/rio";
      sparseCheckout = [ "themes" ];
      hash = "sha256-EHv3e4QprL82arOBpa/81viXzEKmYjp+IK/9J+T0VL4=";
    }).outPath + "/themes";
  };
}
