{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  # ZenTerm 本体は brew cask も nixpkgs も無く、アプリ自身が自動更新するので
  # https://github.com/praxis-labs-io/zen-term/releases の dmg から /Applications へ手で入れる。
  # config はホストごとに hosts/*/home.nix で ~/.config/zen-term/config へ symlink する
  home.packages = [ pkgs.zmx ];

  # Settings 画面からの変更は symlink を辿ってリポジトリ側に書かれる
  home.file = {
    ".config/zen-term/themes/peafowl.conf".source = mkOutOfStoreSymlink
      "${homeDirectory}/ghq/github.com/peacock0803sz/peafowl-colors/ghostty/peafowl.conf";
    ".config/zen-term/workspaces".source = mkOutOfStoreSymlink
      "${homeDirectory}/dotfiles/dot_config/zen-term/workspaces";
  };
}
