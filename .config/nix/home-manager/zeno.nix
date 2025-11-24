{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".local/share/fish/plugins/zeno.zsh".source = (pkgs.fetchgit {
      url = "https://github.com/yuki-yano/zeno.zsh";
      hash = "sha256-fk4CEGd2CufYwN3kgoJ0tpfuz7GHQdU+2SLYRBmZ10Q=";
    }).outPath;
    ".config/fish/conf.d/zeno.fish".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.local/share/fish/plugins/zeno.zsh/shells/fish/conf.d/zeno.fish";
    ".config/zeno".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zeno";
  };
}
