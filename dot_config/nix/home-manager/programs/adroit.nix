{ pkgs, config, inputs, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  home.packages = [ inputs.adroit.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  home.file = {
    # ".config/adroit/console/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/nvim.aibo";
    ".config/adroit/prompt/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/nvim.aibo";
  };
}
