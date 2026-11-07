# oksskolten - AI-native RSS reader
# https://github.com/babarot/oksskolten
{ config, pkgs, username, ... }:
let
  # Samba 共有 (/mnt/Eggplants) の配下で、rss.db には API キーや JWT シークレットが入る。
  # 共有から読めないよう root 専用にしておく
  hddRoot = "/mnt/Eggplants/ST4000VN006/oksskolten";
  backupDir = "/var/lib/oksskolten-backup";
  serverPort = 3002; # 3000 は Gitea、3001 は Grafana が使用中

  # firewall が無効なので、compose.yaml の 0.0.0.0 publish を塞いで nginx 経由だけにする。
  # dockerd の自動再起動だと HDD のマウント前に起動しうるので restart は切り、systemd に任せる
  composeOverride = pkgs.writeText "oksskolten-compose.override.yaml" ''
    services:
      server:
        ports: !override
          - "127.0.0.1:${toString serverPort}:3000"
      frontend:
        ports: !override
          - "127.0.0.1:5173:5173"
      meilisearch:
        restart: "no"
        mem_limit: 3g
        environment:
          MEILI_MAX_INDEXING_MEMORY: 1GiB
        volumes: !override
          - ${hddRoot}/meili:/meili_data
        ports: !override []
      rss-bridge:
        restart: "no"
        ports: !override []
      flaresolverr:
        restart: "no"
        ports: !override []
  '';
  compose = "${pkgs.docker}/bin/docker compose -f compose.yaml -f ${composeOverride}";
in
{
  # oksskolten systemd service: docker compose up --build {{{
  systemd.services.oksskolten = {
    description = "The AI-native RSS reader; https://github.com/babarot/oksskolten";

    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "network-online.target" ];
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];
    # マウントは nofail なので、これがないと HDD がないまま SSD 側に空の DB を作ってしまう
    unitConfig.RequiresMountsFor = hddRoot;
    environment.DATA_DIR = "${hddRoot}/data";
    serviceConfig = {
      Type = "simple";
      User = username;
      WorkingDirectory = "/home/${username}/oksskolten";
      ExecStart = "${compose} up --build";
      ExecStop = "${compose} down";
      Restart = "on-failure";
      RestartSec = 10;
    };
    path = [ pkgs.docker ];
  };

  systemd.tmpfiles.rules = [
    "d ${hddRoot} 0700 root root -"
    "d ${hddRoot}/data 0700 root root -"
    "d ${hddRoot}/meili 0700 root root -"
    "d ${backupDir} 0700 root root -"
  ];
  # }}}

  # rss.db の日次バックアップ (HDD 故障に備えて SSD に 7 日分残す) {{{
  systemd.services.oksskolten-backup = {
    description = "Back up oksskolten rss.db to SSD";
    unitConfig.RequiresMountsFor = hddRoot;
    serviceConfig.Type = "oneshot";
    path = [ pkgs.sqlite pkgs.coreutils pkgs.findutils ];
    script = ''
      sqlite3 ${hddRoot}/data/rss.db ".backup ${backupDir}/rss-$(date +%F).db"
      find ${backupDir} -name 'rss-*.db' -mtime +7 -delete
    '';
  };

  systemd.timers.oksskolten-backup = {
    description = "Timer for oksskolten rss.db backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "03:30";
      Persistent = true;
    };
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
        proxyPass = "http://127.0.0.1:${toString serverPort}";
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
