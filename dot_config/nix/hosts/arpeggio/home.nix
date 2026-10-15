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
    brewCasks.finetune
  ];

  home.file = {
    ".config/ghostty/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ghostty/arpeggio.config";
    "Library/Application Support/felis/config.toml".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/felis/arpeggio.toml";
    ".ssh/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ssh/arpeggio.override.config";
  };
}
