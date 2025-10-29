{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "24.11";
  home.file = {
    # ".gitconfig".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/git/.gitconfig.nixos";
  };
}
