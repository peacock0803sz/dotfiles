{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = with pkgs; [
    keto
    kratos
    ory
  ];

  home.file = {
    ".config/ghostty/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/ghostty/arpeggio.config";
  };
}
