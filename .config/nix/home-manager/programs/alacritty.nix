{ pkgs, ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    ".config/alacritty/alacritty.toml".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/alacritty/alacritty.toml";
    ".config/alacritty/catppuccin-latte.toml".source = (pkgs.fetchgit {
      url = "https://github.com/catppuccin/alacritty";
      hash = "sha256-H8bouVCS46h0DgQ+oYY8JitahQDj0V9p2cOoD4cQX+Q=";
    }).outPath + "/catppuccin-latte.toml";
  };
}
