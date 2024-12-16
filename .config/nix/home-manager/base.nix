{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "24.11";
  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.gitconfig";
    ".config/bat".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/bat";
    ".config/nvim".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";
    ".local/share/gh/extensions/gh-fish/gh-copilot-alias.fish".source = (pkgs.fetchgit {
      url = "https://github.com/DevAtDawn/gh-fish/";
      hash = "sha256-QNk3FXzmLc8KqP3xpkAJT+otKI6fgwXcYS/TgFElCsg=";
    }).outPath + "/gh-copilot-alias.fish";
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
