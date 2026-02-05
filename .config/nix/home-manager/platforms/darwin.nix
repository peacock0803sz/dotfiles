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
    _1password-cli

    brewCasks.bartender
    brewCasks.cleanshot
    brewCasks.contexts
    brewCasks.coteditor
    brewCasks.dataspell
    brewCasks.deskpad
    brewCasks.discord
    brewCasks.elgato-stream-deck
    brewCasks.fantastical
    brewCasks.firefox
    brewCasks.jetbrains-toolbox
    brewCasks.keycastr
    brewCasks.linear-linear
    brewCasks.marta
    brewCasks.musescore
    brewCasks.obs
    brewCasks.orbstack
    brewCasks.raycast
    brewCasks.slack
    brewCasks.utm
    brewCasks.visual-studio-code
    brewCasks.vlc

    (brewCasks.google-chrome.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-P1TxSLJRp8hmnHWPk3dLR4frHTWS9JOS+kAVxVEyaWA=";
      };
    }))
    (brewCasks."google-chrome@beta".overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-8c1WMlyUUs4qLykVruU4lQivwLFIzf5h+SK3P6YBCtw=";
      };
    }))
    (brewCasks."google-chrome@dev".overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-qISondoANSRxLCXItMV1ynXOHKX52X4wBD2rbzVKgzk=";
      };
    }))
    (brewCasks.istat-menus.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-yD9gfObD2z2krFKflq/nalAwY8wh0CtCwx+2f2oRRaY=";
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
      "${config.home.homeDirectory}/dotfiles/.config/git/.gitconfig.darwin";
    ".ssh/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/ssh/config.darwin";
    ".config/karabiner/karabiner.json".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/karabiner/karabiner.json";
  };
}
