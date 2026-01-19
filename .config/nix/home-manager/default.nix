{ ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.stateVersion = "25.11";
  home.file = {
    ".config/bat".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/bat";
    ".config/lnav/config.json".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/lnav/config.json";
    ".config/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/nvim";
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''source $HOME/dotfiles/.config/fish/config.fish'';
    };
  };
}
