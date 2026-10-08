{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  gx-nur = (builtins.getFlake "git+ssh://git@github.com/groove-x/gx-nur").packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    brewCasks.chatgpt
    (brewCasks.claude.overrideAttrs (oldAttrs: {
      postFixup = (oldAttrs.postFixup or "") + ''
        rm -f $out/bin/claude
      '';
    }))

    nur.repos.peacock0803sz.aqua
    gx-nur.gxcloud-cli
    gx-nur.lovot-tools

    yarn
    lefthook

    grpcurl
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
