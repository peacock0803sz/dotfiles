{ pkgs, config, ... }:
let
  # presetレベル -> dot_config/nvim/ 配下の実ディレクトリ
  # large と huge は現状同一の内容なので両方 large を指す
  configDir = {
    tiny = "tiny";
    small = "small";
    large = "large";
    huge = "huge";
  }.${config.profile.level};
in
{
  home.packages = with pkgs; [
    neovim
    tree-sitter
  ];

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/nvim/${configDir}";
}
