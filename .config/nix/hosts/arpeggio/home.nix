{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = with pkgs; [
    brewCasks.figma
    brewCasks.wrike
    brewCasks.appvolume

    (brewCasks."google-chrome@canary".overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-aim+KISg5jSy1t63NhnkeHZDY2B69VzBJM6fyQRXNiE=";
      };
    }))
  ];

  home.file = {
    ".config/ghostty/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/ghostty/arpeggio.config";
  };
}
