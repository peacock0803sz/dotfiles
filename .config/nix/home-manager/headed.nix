{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    "Pictures/wallpapaers/mewtwo.png".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/klaudiosinani/hyper-pokemon/refs/heads/master/backgrounds/mewtwo.png";
      hash = "sha256-VKjW8NBMXSsx6H07AmaRJ4U1skIs5Ld8S+VtLTHGw8w=";
    };

    ".config/alacritty".source = mkOutOfStoreSymlink ~/dotfiles/.config/alacritty;
    ".config/wezterm".source = mkOutOfStoreSymlink ~/dotfiles/.config/wezterm;
    ".config/rio/config.toml".source = mkOutOfStoreSymlink ~/dotfiles/.config/rio/config.toml;
    ".config/rio/themes".source = (pkgs.fetchgit {
      url = "https://github.com/catppuccin/rio";
      sparseCheckout = [ "themes" ];
      hash = "sha256-EHv3e4QprL82arOBpa/81viXzEKmYjp+IK/9J+T0VL4=";
    }).outPath + "/themes";
  };
}
