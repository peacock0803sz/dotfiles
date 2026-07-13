{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ../programs/alacritty.nix
    ../programs/ghostty.nix
    ../programs/wezterm.nix
  ];

  home.packages = with pkgs; [
    git
    defaultbrowser

    brewCasks.bartender
    brewCasks.cleanshot
    brewCasks.contexts
    brewCasks.coteditor
    brewCasks.deskpad
    brewCasks.discord
    brewCasks.element
    brewCasks.elgato-stream-deck
    brewCasks.fantastical
    brewCasks.firefox
    brewCasks.keycastr
    brewCasks.linear
    brewCasks.marta
    brewCasks.mimestream
    brewCasks.obs
    brewCasks.orbstack
    brewCasks.plaud
    (brewCasks.raycast.overrideAttrs (oldAttrs: {
      src = oldAttrs.src.overrideAttrs (_: { name = "raycast.dmg"; });
    }))
    brewCasks.slack
    brewCasks.utm
    (brewCasks.visual-studio-code.overrideAttrs (oldAttrs: {
      src = oldAttrs.src.overrideAttrs (_: { name = "stable.zip"; });
    }))
    brewCasks.vlc

    (brewCasks.istat-menus.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-qCgMEUjHUsEP+B+e2nylse9T/Xnt765RzV0WtBSWSPY=";
      };
    }))
    (brewCasks.lasso-app.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-n+wxLHnA/LI42LRXvWC3jgJfmdmrUK3lncBwHt7UhuE=";
      };
    }))
  ];

  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/git/.gitconfig.darwin";
    ".config/karabiner/karabiner.json".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/karabiner/karabiner.json";
  };
}
