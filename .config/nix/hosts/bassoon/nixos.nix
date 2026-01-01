{ wodulePath, pkgs, config, ... }: {
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
        eggplants = {
          "path" = "/mnt/Eggplants";
          "browseable" = "yes";
          "writable" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "peacock";
          "force group" = "wheel";
        };
      };
    };
    nginx = {
      enable = true;
      virtualHosts."notizen.p3ac0ck.net" = {
        acmeRoot = null;
        forceSSL = true;
        useACMEHost = "notizen.p3ac0ck.net";
        # enableACME = true;
        listenAddresses = [ "0.0.0.0" "[::1]" ];
        locations."/" = {
          root = "/var/www/notizen/";
          index = "index.html";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "me@p3ac0ck.net";

    certs."notizen.p3ac0ck.net" = {
      dnsProvider = "cloudflare";
      group = config.services.nginx.group;
      environmentFile = "/var/lib/acme/cloudflare.env";
    };
  };
  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
  systemd.tmpfiles.rules = [
    # /home/peacock を nginx が通過できるように + mask も通す
    "a /home/peacock - - - - u:nginx:--x,m::--x"

    # 公開ディレクトリ配下は読めるように + mask も広げる（保険）
    "A /home/peacock/Documents/notizen/build/html - - - - u:nginx:rX,m::rX"
  ];
  systemd.services = { };

  fonts.packages = with pkgs; [
    udev-gothic-nf
  ];

  environment.systemPackages = with pkgs; [
    cron
  ];
}
