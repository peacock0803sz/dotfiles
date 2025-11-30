{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "25.11";
  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/git/.gitconfig.nixos";
    ".config/bat".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/bat";
    ".config/nvim".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";
  };
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''source $HOME/dotfiles/.config/fish/config.fish'';
    };
  };
}
