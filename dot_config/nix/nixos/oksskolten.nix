# oksskolten - AI-native RSS reader
# https://github.com/babarot/oksskolten
{ config, pkgs, username, ... }: {
  # oksskolten systemd service: docker compose up --build {{{
  systemd.services.oksskolten = {
    description = "The AI-native RSS reader; https://github.com/babarot/oksskolten";

    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "network-online.target" ];
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      User = username;
      WorkingDirectory = "/home/${username}/oksskolten";
      ExecStart = "${pkgs.docker}/bin/docker compose up --build";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      Restart = "on-failure";
      RestartSec = 10;
    };
    path = [ pkgs.docker ];
  };
  # }}}

  # Nginx Reverse Proxy (Tailscale network only) {{{
  services.nginx = {
    enable = true;

    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts."rss.p3ac0ck.net" = {
      acmeRoot = null;
      forceSSL = true;
      useACMEHost = "rss.p3ac0ck.net";
      listenAddresses = [ "0.0.0.0" ];

      locations."/" = {
        proxyPass = "http://127.0.0.1:5173";
        proxyWebsockets = true;
      };

      locations."/api/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 10m;
        '';
      };
    };
  };
  # }}}

  # ACME / Let's Encrypt (DNS-01 via Cloudflare) {{{
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@p3ac0ck.net";

    certs."rss.p3ac0ck.net" = {
      dnsProvider = "cloudflare";
      group = config.services.nginx.group;
      environmentFile = "/var/lib/acme/cloudflare.env";
      # lego の DNS 伝播チェックに Cloudflare DNS を使う
      # (デフォルトだと Tailscale MagicDNS 100.100.100.100 が使われ、TXT レコードの伝播を検出できない)
      extraLegoFlags = [ "--dns.resolvers=1.1.1.1:53" ];
    };
  };
  # }}}
}
