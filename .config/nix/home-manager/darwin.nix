{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/git/.gitconfig.darwin";
    ".config/karabiner/karabiner.json".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/karabiner/karabiner.json";
    ".config/nvim.aibo".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim.aibo";
  };
}
