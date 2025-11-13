{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".config/ghostty/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/ghostty/arpeggio.config";
  };
}
