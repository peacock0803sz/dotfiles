# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ ... }@inputs:
{
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
      group = inputs.config.services.nginx.group;
      environmentFile = "/var/lib/acme/cloudflare.env";
    };
  };
  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

  # Periodic build and deploy for notizen documentation
  systemd.services.notizen-build = {
    description = "Build notizen and deploy to web server";
    serviceConfig = {
      Type = "oneshot";
      User = inputs.username;
      WorkingDirectory = "/home/${inputs.username}/notizen";
      ExecStart = "${inputs.pkgs.writeShellScript "notizen-build" ''
        ${inputs.pkgs.gnumake}/bin/make html
        ${inputs.pkgs.rsync}/bin/rsync -av --delete build/html/ /var/www/notizen/
      ''}";
    };
    path = [ inputs.pkgs.gnumake inputs.pkgs.rsync ];
  };

  systemd.timers.notizen-build = {
    description = "Timer for notizen build";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/www/notizen 0755 ${inputs.username} nginx -"
  ];
}
