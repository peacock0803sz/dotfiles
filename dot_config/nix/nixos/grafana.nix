{ lib, pkgs, ... }:
let
  domain = "grafana.p3ac0ck.net";
  httpPort = 3001; # 3000 は gitea が使用中
  nginxPort = 8080;
  prometheusPort = 9090;
  nodeExporterPort = 9100;
  # gitea.nix と同じトンネルに相乗りする。ingress は attrset なのでマージされる
  tunnelId = "5ac81ddd-325b-4dab-8fc5-c5e4b381f8ab";
in
{
  # Grafana {{{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        inherit domain;
        root_url = "https://${domain}/";
        http_addr = "127.0.0.1"; # 外部への口は cloudflared -> nginx のみ
        http_port = httpPort;
        enable_gzip = true;
      };

      # TLS は Cloudflare が終端する
      security = {
        # 未設定だと Grafana 組み込みの公開された既定鍵が使われてしまう。
        # Nix store に平文で残さないよう file provider で外部ファイルを参照する
        secret_key = "$__file{/var/lib/grafana/secret_key}";

        cookie_secure = true;
        cookie_samesite = "lax";
      };

      # 外部への情報送信とアップデート通知を止める
      analytics = {
        reporting_enabled = false;
        check_for_updates = false;
        check_for_plugin_updates = false;
      };

      users.allow_sign_up = false;
    };

    # Prometheus をデータソースとして宣言的に投入する
    # (UI で編集しても再起動時にここの内容で上書きされる)
    provision = {
      enable = true;

      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "Prometheus";
            uid = "prometheus";
            type = "prometheus";
            # proxy = Grafana サーバ側から引く。localhost 束縛の Prometheus に届かせるため
            access = "proxy";
            url = "http://127.0.0.1:${toString prometheusPort}";
            isDefault = true;
          }
        ];
      };
    };
  };
  # }}}

  # Prometheus {{{
  services.prometheus = {
    enable = true;
    # firewall が無効なので、既定の 0.0.0.0 のままだと LAN に露出する
    listenAddress = "127.0.0.1";
    port = prometheusPort;
    retentionTime = "90d";

    globalConfig = {
      scrape_interval = "15s";
      evaluation_interval = "15s";
    };

    exporters.node = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = nodeExporterPort;
      # 既定のコレクタ (cpu/meminfo/diskstats/filesystem/netdev/hwmon 等) への追加分
      enabledCollectors = [ "systemd" "processes" ];
    };

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString nodeExporterPort}" ];
            labels.instance = "bassoon";
          }
        ];
      }
    ];
  };
  # }}}

  # systemd {{{
  # secret_key を初回起動時に生成する。
  # DB 内のシークレット (データソースのパスワード等) の暗号化に使われ、
  # 後から変えると復号できなくなるので一度作ったら消さないこと
  systemd.services.grafana.preStart = ''
    if [ ! -e /var/lib/grafana/secret_key ]; then
      umask 077
      ${pkgs.openssl}/bin/openssl rand -hex 32 > /var/lib/grafana/secret_key
    fi
  '';
  # }}}

  # Nginx {{{
  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts.${domain} = {
      listen = lib.mkForce [
        { addr = "127.0.0.1"; port = nginxPort; }
      ];

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString httpPort}";
        proxyWebsockets = true; # Live/Explore のストリーミングに必要
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto https;
        '';
      };
    };
  };
  # }}}

  # Cloudflare Tunnel {{{
  # tunnels.<id> の credentialsFile / default は gitea.nix 側で定義済み。
  # ここでは ingress に 1 エントリ足すだけでマージされる
  services.cloudflared.tunnels.${tunnelId}.ingress.${domain} = {
    service = "http://127.0.0.1:${toString nginxPort}";
  };
  # }}}
}
