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
      hash = "sha256-c9K3p/6+uQghgQ/Jx++iE2fv4vrUVeKmxce0BqAojOQ=";
    }).outPath + "/themes";
  };
}
