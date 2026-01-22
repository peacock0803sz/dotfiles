{ modulePath, pkgs, config, ... }: {
  programs = { };

  systemd.services = { };

  fonts.packages = with pkgs; [
    udev-gothic-nf
  ];

  environment.systemPackages = with pkgs; [
    cron
  ];
  virtualisation.docker.enable = true;
}
