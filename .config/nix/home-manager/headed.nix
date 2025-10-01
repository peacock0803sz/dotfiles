{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".tmux.conf".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.tmux.conf";
    ".config/alacritty/alacritty.toml".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/alacritty/alacritty.toml";
    ".config/alacritty/catppuccin-latte.toml".source = (pkgs.fetchgit {
      url = "https://github.com/catppuccin/alacritty";
      hash = "sha256-H8bouVCS46h0DgQ+oYY8JitahQDj0V9p2cOoD4cQX+Q=";
    }).outPath + "/catppuccin-latte.toml";
    ".config/wezterm".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/wezterm";
    ".config/rio/config.toml".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/rio/config.toml";
    ".config/rio/themes".source = (pkgs.fetchgit {
      url = "https://github.com/catppuccin/rio";
      sparseCheckout = [ "themes" ];
      hash = "sha256-JDHD7P28rKR6MLhENGvBpDzOmtDhPgH8YAnYjwLLGq4=";
    }).outPath + "/themes";
    ".config/ghostty/config".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/ghostty/config";
    ".config/ghostty/themes".source = (pkgs.fetchgit {
      url = "https://github.com/catppuccin/ghostty";
      sparseCheckout = [ "themes" ];
      hash = "sha256-PrvKSKnPgeXtlTdWJNyz8EcQDlCHxOH1fgaiHbMec2o=";
    }).outPath + "/themes";
  };
}
