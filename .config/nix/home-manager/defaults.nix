{ config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink ~/dotfiles/.gitconfig;
    ".config/bat".source = mkOutOfStoreSymlink ~/dotfiles/.config/bat;
    ".config/nvim".source = mkOutOfStoreSymlink ~/dotfiles/.config/nvim;
    ".config/obsidian.nvim".source = mkOutOfStoreSymlink ~/.config/obsidian.nvim;
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''source $HOME/dotfiles/.config/fish/config.fish'';
    };
    direnv = {
      enable = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
