{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  services.ssh-agent.enable = true;

  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dot_config/git/.gitconfig.nixos";
  };
}
