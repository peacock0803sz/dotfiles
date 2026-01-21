{ ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    ".config/nvim.aibo".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/nvim.aibo";
  };
}
