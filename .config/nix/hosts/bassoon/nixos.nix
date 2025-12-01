{ wodulePath, pkgs, ... }: {
  programs = { };

  services = {
    samba = {
      enable = true;
      smbd.enable = true;
      openFirewall = true;
      settings = {
        global = {
          workgroup = "wheel";
          "log file" = "/var/log/samba/log.%m";
          "max log size" = 1000;
          logging = "file";

          "invalid users" = [ "root" ];
          "passwd program" = "/run/wrappers/bin/passwd %u";
          security = "user";
        };
        peacock = {
          "path" = "/home/peacock";
          "browseable" = "yes";
          "writable" = "yes";
          "create mask" = "0775";
          "directory mask" = "0775";
          "force user" = "peacock";
          "force group" = "wheel";
        };
        eggplants = {
          "path" = "/mnt/Eggplants";
          "browseable" = "yes";
          "writable" = "yes";
          "create mask" = "0775";
          "directory mask" = "0775";
          "force user" = "peacock";
          "force group" = "wheel";
        };
      };
    };
  };

  systemd.services = { };

  fonts.packages = with pkgs; [
    udev-gothic-nf
  ];

  # environment.systemPackages = with pkgs; [  ];
}
