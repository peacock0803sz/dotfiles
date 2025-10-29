{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/git/.gitconfig.nixos";
  };

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    systemd.variables = [ "--all" ];
    extraConfig = "source = ~/dotfiles/.config/hypr/hyprland.conf";
  };
}
