{ wodulePath, pkgs, ... }:
let
  username = "peacock";
in
{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
    uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };
    };
  };

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = username;
      };
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "where_is_my_sddm_theme";
        settings = {
          AutoLogin = {
            Session = "hyprland-uwsm";
            User = username;
          };
        };
      };
    };
    gnome.gnome-keyring.enable = true;
    xserver.enable = true;
  };

  systemd.services = { };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-emoji
    jetbrains-mono
    udev-gothic-nf
  ];

  environment.systemPackages = with pkgs; [
    x11basic
    wayland
    wayland-protocols
    xwayland
    wl-clipboard
    # lemonade
    where-is-my-sddm-theme
    pipewire
    wtype
    hyprland
    hyprland-protocols
    hyprland-workspaces
    hyprland-monitor-attached
    rofi
    rofi-systemd
    rofi-wayland
    rofi-screenshot
    rofi-power-menu
    rofi-file-browser
    rofi-emoji-wayland
    rofi-calc
    mako
    wezterm
  ];
}
