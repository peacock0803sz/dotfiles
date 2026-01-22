# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, modulesPath, system, pkgs, nix-monitored, ... }:

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
      group = config.services.nginx.group;
      environmentFile = "/var/lib/acme/cloudflare.env";
    };
  };
  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
}
