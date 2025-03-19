{ modulePath, pkgs, ... }:

{
  programs = {
    hyprland.enable = true;
  };

  services = {
    xserver.enable = true;
    greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;
      settings = {
        default_session = {
          command = "${pkgs.lib.getExe pkgs.greetd.tuigreet} --time --remember --remember-session --cmd niri";
          user = "greeter";
        };
      };
    };
    gnome.gnome-keyring.enable = true;
  };

  systemd.services.greetd.serviceConfig = {
    Type = "Idle";
    StandardInputs = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  fonts.packages = with pkgs; [
    moralerspace-hwnf
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liga-hackgen-nf-font
  ];

  environment.systemPackages = with pkgs; [
    sddm
    x11basic
    pixman
    cairo
    pango
    libinput
    libliftoff
    cpio
    wayland
    wayland-protocols
    wl-clipboard
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
