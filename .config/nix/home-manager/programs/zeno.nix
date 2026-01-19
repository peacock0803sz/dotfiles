{ pkgs, ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    ".local/share/fish/plugins/zeno.zsh".source = (pkgs.fetchgit {
      url = "https://github.com/yuki-yano/zeno.zsh";
      hash = "sha256-fk4CEGd2CufYwN3kgoJ0tpfuz7GHQdU+2SLYRBmZ10Q=";
    }).outPath;
    ".config/fish/conf.d/zeno.fish".source = mkOutOfStoreSymlink
      "${homeDirectory}/.local/share/fish/plugins/zeno.zsh/shells/fish/conf.d/zeno.fish";
    ".config/zeno".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/zeno";
  };
}
