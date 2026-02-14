{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = with pkgs; [
    brewCasks.figma
    brewCasks.wrike
  ];

  home.file = {
    ".config/ghostty/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/ghostty/arpeggio.config";
  };
}
