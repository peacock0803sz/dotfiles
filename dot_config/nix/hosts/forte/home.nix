{ config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".ssh/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ssh/config.nixos";
  };
}
