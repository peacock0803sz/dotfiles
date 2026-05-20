{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = with pkgs; [
    brewCasks.chatgpt
    (brewCasks.claude.overrideAttrs (oldAttrs: {
      postFixup = (oldAttrs.postFixup or "") + ''
        rm -f $out/bin/claude
      '';
    }))
    (brewCasks.google-gemini.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-z8XyaH6XziFsKgyWUwtH8Af6cQ4J/4kT0Fcn7YHt4Zo=";
      };
    }))

    keto
    kratos
    ory
  ];

  home.file = {
    ".config/ghostty/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ghostty/arpeggio.config";
    ".ssh/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ssh/arpeggio.override.config";
  };
}
