# 本体 (Adroit.app と adroit コマンド) は nix-darwin の homebrew cask で入れる (nix-darwin/workstation.nix)
{ config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  home.file = {
    # ".config/adroit/console/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/nvim.aibo";
    ".config/adroit/prompt/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/nvim.aibo";
  };
}
