{ modulePath, pkgs, config, ... }: {
  programs = { };

  services = {
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
  systemd.services = { };

  fonts.packages = with pkgs; [
    udev-gothic-nf
  ];

  environment.systemPackages = with pkgs; [
    cron
  ];
  virtualisation.docker.enable = true;
}
