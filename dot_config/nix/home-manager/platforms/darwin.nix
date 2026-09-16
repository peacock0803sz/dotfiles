{ pkgs, lib, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  karabinerConfig = ../../../karabiner/karabiner.json;
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
    brewCasks.element
    brewCasks.elgato-stream-deck
    brewCasks.fantastical
    brewCasks.firefox
    brewCasks.keycastr
    brewCasks.linear
    brewCasks.marta
    brewCasks.mimestream
    brewCasks.obs
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
        hash = "sha256-PhgH8ue6Z5Amf7PIA2oQEDyQIn1XIuu6QeeRelRMcuU=";
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
  };

  # Karabiner-Elements は GUI 操作や起動時の正規化で karabiner.json を書き戻すため、
  # symlink だと参照先の実体 (リポジトリや store) を壊す。
  # build 時に store へ取り込んだ内容を実ファイルとしてコピー配置し、nix 側を正として乖離したら上書きする。
  home.activation.karabinerConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run mkdir -p "$HOME/.config/karabiner"
    if [ -L "$HOME/.config/karabiner/karabiner.json" ]; then
      run rm -f "$HOME/.config/karabiner/karabiner.json"
    fi
    if ! ${pkgs.diffutils}/bin/cmp -s ${karabinerConfig} "$HOME/.config/karabiner/karabiner.json" 2>/dev/null; then
      run install -m 644 ${karabinerConfig} "$HOME/.config/karabiner/karabiner.json"
    fi
  '';
}
