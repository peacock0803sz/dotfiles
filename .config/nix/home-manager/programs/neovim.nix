{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  home.packages = with pkgs; [
    neovim
    tree-sitter
  ];
  home.file = {
    ".config/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/nvim";
  };
}
