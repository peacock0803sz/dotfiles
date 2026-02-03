{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  home.packages = with pkgs; [
    tmux
    tmuxPlugins.catppuccin
    tmuxPlugins.tmux-fzf
  ];

  home.file = {
    ".tmux.conf".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/tmux/conf";
  };
}
