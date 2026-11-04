{ ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    # ".config/adroit/console/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/nvim.aibo";
    ".config/adroit/prompt/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/nvim.aibo";
  };
}
