{ ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    ".config/bat".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/bat";
  };
}
