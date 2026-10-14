{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".config/ghostty/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ghostty/nocturne.config";
    "Library/Application Support/felis/config.toml".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/felis/nocturne.toml";
    ".ssh/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ssh/config.darwin";
  };
}
