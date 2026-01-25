{ ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.packages = with inputs.pkgs; [
    tmux
    tmuxPlugins.catppuccin
    tmuxPlugins.tmux-fzf
  ];

  home.file = {
    ".tmux.conf".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.tmux.conf";
  };
}
