{ wodulePath, pkgs, ... }:
let
  username = "peacock";
in
{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  services = {
    xserver.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = username;
      };
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland.enable = true;
        settings = {
          AutoLogin = {
            Session = "hyprland";
            User = username;
          };
        };
      };
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-emoji
    jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    x11basic
    wayland
    wayland-protocols
    xwayland
    wl-clipboard
    lemonade
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
    wezterm
  ];
}
