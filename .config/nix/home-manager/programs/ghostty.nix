{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    # ".config/ghostty/themes/catppuccin-latte.conf".source = (pkgs.fetchgit {
    #   url = "https://github.com/catppuccin/ghostty";
    #   sparseCheckout = [ "themes" ];
    #   hash = "sha256-6w8+zIrXaOQZLF71VIiU55xMsrzupnzkGDUmAefpMqg=";
    # }).outPath + "/themes/catppuccin-latte.conf";

    # $HOME/ghq/github.com/peacock0803sz/peafowl-colors/ghostty/peafowl.conf
    ".config/ghostty/themes/peafowl.conf".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/ghq/github.com/peacock0803sz/peafowl-colors/ghostty/peafowl.conf";
  };
  home.packages = if pkgs.stdenv.isDarwin then [ pkgs.brewCasks.ghostty ] else [ pkgs.ghostty ];
}
