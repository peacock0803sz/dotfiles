{ config, pkgs, ... }:
let
  domain = "grafana.p3ac0ck.net";
  httpPort = 3001; # 3000 は gitea が使用中
  prometheusPort = 9090;

  # 収集対象とポートの単一の情報源。被収集ホスト側 (enigma) の
  # nixos/prometheus-exporters.nix も同じファイルを読んでいる
  targets = import ./prometheus-targets.nix;

  target = host: port: "${host.address}:${toString port}";
in
{
  # Grafana {{{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        inherit domain;
        root_url = "https://${domain}/";
        http_addr = "127.0.0.1"; # 外部への口は前段の nginx のみ
        http_port = httpPort;
        enable_gzip = true;
      };

      # TLS は前段の nginx が ACME 証明書で終端する
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
      listenAddress = targets.bassoon.address;
      port = targets.bassoon.ports.node;
      # 既定のコレクタ (cpu/meminfo/diskstats/filesystem/netdev/hwmon 等) への追加分
      enabledCollectors = [ "systemd" "processes" ];
    };

    # enigma へは LAN 経由で引く。enigma 側の exporter は tailscale0 に出さず
    # LAN IP に bind してある (nixos/prometheus-exporters.nix)
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ (target targets.bassoon targets.bassoon.ports.node) ];
            labels.instance = "bassoon";
          }
          {
            targets = [ (target targets.enigma targets.enigma.ports.node) ];
            labels.instance = "enigma";
          }
        ];
      }
      {
        job_name = "nvidia-gpu";
        static_configs = [
          {
            targets = [ (target targets.enigma targets.enigma.ports.nvidia) ];
            labels.instance = "enigma";
          }
        ];
      }
      {
        job_name = "cadvisor";
        # コンテナ数 × メトリクス数で系列が増えやすい。
        # 15s × 90d 保持だと TSDB が膨らむのでこの job だけ間隔を伸ばす
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [ (target targets.enigma targets.enigma.ports.cadvisor) ];
            labels.instance = "enigma";
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
      # tailnet 内から直接叩く。DNS は grafana.p3ac0ck.net -> bassoon.tail2121a.ts.net
      # の CNAME (DNS only)。git.p3ac0ck.net の vhost は 127.0.0.1:8081 に
      # listen を固定してあるので、ここで 0.0.0.0 を開いても干渉しない
      acmeRoot = null;
      forceSSL = true;
      useACMEHost = domain;
      listenAddresses = [ "0.0.0.0" ];

      locations."/" = {
        # X-Forwarded-Proto は recommendedProxySettings が $scheme で入れる
        proxyPass = "http://127.0.0.1:${toString httpPort}";
        proxyWebsockets = true; # Live/Explore のストリーミングに必要
      };
    };
  };
  # }}}

  # ACME / Let's Encrypt (DNS-01 via Cloudflare) {{{
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@p3ac0ck.net";

    certs.${domain} = {
      dnsProvider = "cloudflare";
      group = config.services.nginx.group;
      # 手置き。CF_DNS_API_TOKEN を 1 行入れる
      environmentFile = "/var/lib/acme/cloudflare.env";
      # lego の DNS 伝播チェックに Cloudflare DNS を使う
      # (既定だと Tailscale MagicDNS 100.100.100.100 が使われ、TXT の伝播を検出できない)
      extraLegoFlags = [ "--dns.resolvers=1.1.1.1:53" ];
    };
  };
  # }}}
}
