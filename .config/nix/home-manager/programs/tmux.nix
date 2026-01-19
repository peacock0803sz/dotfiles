{ ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    ".tmux.conf".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.tmux.conf";
  };
}
