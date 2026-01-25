{ ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.packages = with inputs.pkgs; [
    lnav
  ];

  home.file = {
    ".config/lnav".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/lnav";
  };
}
