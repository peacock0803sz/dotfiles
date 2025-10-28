{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "24.11";
  home.file = {
    ".config/bat".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/bat";
    ".config/lnav/config.json".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/lnav/config.json";
    ".config/nvim".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";
    # ".config/fish/config.fish".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/fish/config.fish";
    ".local/share/gh/extensions/gh-fish/gh-copilot-alias.fish".source = (pkgs.fetchgit {
      url = "https://github.com/DevAtDawn/gh-fish/";
      hash = "sha256-QNk3FXzmLc8KqP3xpkAJT+otKI6fgwXcYS/TgFElCsg=";
    }).outPath + "/gh-copilot-alias.fish";

    # zeno.zsh {{{
    ".local/share/fish/plugins/zeno.zsh".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/ghq/github.com/peacock0803sz/zeno.zsh";
    # ".local/share/fish/plugins/zeno.zsh".source = (pkgs.fetchgit {
    #   url = "https://github.com/yuki-yano/zeno.zsh";
    #   hash = "sha256-fk4CEGd2CufYwN3kgoJ0tpfuz7GHQdU+2SLYRBmZ10Q=";
    # }).outPath;
    ".config/fish/conf.d/zeno.fish".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.local/share/fish/plugins/zeno.zsh/shells/fish/conf.d/zeno.fish";
    ".config/zeno".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zeno";
    # }}}
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
