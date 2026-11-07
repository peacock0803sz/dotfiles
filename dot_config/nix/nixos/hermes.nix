# Hermes Agent を Bot Screen (Xvnc + Xfce) 付きのコンテナで常駐させる。
# ボットの terminal / 画面 / ブラウザ / computer_use はすべてコンテナ内で完結する
# https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/features/bot-screen.md
#
# 手で置くもの: /var/lib/hermes/hermes.env (root:root 0600)。無いとコンテナが起動しない
#   HERMES_DASHBOARD_BASIC_AUTH_USERNAME=...
#   HERMES_DASHBOARD_BASIC_AUTH_PASSWORD=...
#   HERMES_DASHBOARD_BASIC_AUTH_SECRET=...
{ config, pkgs, ... }:
let
  stateDir = "/var/lib/hermes";
  dataDir = "${stateDir}/data";
  envFile = "${stateDir}/hermes.env";

  # 画像の更新は digest ごと手で上げる。-desktop タグに TigerVNC と Xfce が入っている
  image = "nousresearch/hermes-agent:v0.23.0-desktop@sha256:399ec6c0052a945b06b38de9d44d26b636237a60e97422d2d81f1c38b8d7c9fd";

  # コンテナ内の hermes ユーザ。stage2 hook が /opt/data をこの UID に chown する
  uid = "10000";

  network = "hermes";
  subnet = "172.30.0.0/24";

  # コンテナから届かせない宛先。ボットは画面経由のプロンプトインジェクションを受け得るが、
  # enigma は networking.firewall.enable = false なので、遮断しないと enigma 本体の
  # サービス、LAN (bassoon など)、tailnet の全ノードへ素通しになる
  blockedCidrs = [
    "10.0.0.0/8"
    "172.16.0.0/12"
    "192.168.0.0/16"
    "100.64.0.0/10" # tailnet
    "169.254.0.0/16"
  ];

  # filter の FORWARD は tailscale の ts-forward と順序を争い、INPUT は別に書く必要がある。
  # mangle の PREROUTING なら経路判定の前に両方を一度に止められる。
  # 公開ポートへの応答は ESTABLISHED なので、NEW だけを落とせば影響しない
  egressRules = action: builtins.concatStringsSep "\n" (map
    (cidr: "${pkgs.iptables}/bin/iptables -w -t mangle ${action} PREROUTING -s ${subnet} -d ${cidr} -m conntrack --ctstate NEW -j DROP")
    blockedCidrs);

  # 初回だけ置く種。hermes model や schema 移行が config.yaml を書き換えるので、
  # Nix store へのリンクにはしない。ここを変えても既存の config.yaml には反映されない
  seedConfig = pkgs.writeText "hermes-config.yaml" (builtins.toJSON {
    webapp = {
      enabled = true;
      # コンテナ内 loopback には公開ポートから届かないので 0.0.0.0 にする。
      # 外への公開範囲は下の ports の 127.0.0.1 で絞る
      host = "0.0.0.0";
      port = 9120;
      # 画面ビューアは secure context が要る。平文 HTTP では localhost 以外だと開けないので、
      # tailnet 直ではなく SSH トンネルで使う
      public_url = "http://localhost:9120";
    };
    terminal.backend = "local";
    bot_desktop = {
      placement = "auto";
      auto_start = true;
    };
    browser.headed = true;
  });
in
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.hermes = {
      inherit image;
      cmd = [ "gateway" "run" ];
      # Docker ソケットや host の秘密は渡さない
      volumes = [ "${dataDir}:/opt/data" ];
      ports = [ "127.0.0.1:9120:9120" ];
      environmentFiles = [ envFile ];
      networks = [ network ];
      extraOptions = [
        # 上流が LAN や MagicDNS だと、上の遮断で組み込み DNS の問い合わせも落ちる
        "--dns=1.1.1.1"
        # gitea-actions-runner などと同居するので使い切らせない
        "--memory=8g"
        "--cpus=3"
        "--pids-limit=2048"
        # Chromium の /dev/shm。既定の 64MB だと落ちる
        "--shm-size=1g"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d ${stateDir} 0750 root root -"
    "d ${dataDir} 0700 ${uid} ${uid} -"
    "C ${dataDir}/config.yaml 0600 ${uid} ${uid} - ${seedConfig}"
  ];

  systemd.services.hermes-network = {
    description = "Docker network and egress rules for Hermes Agent";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    before = [ "docker-hermes.service" ];
    requiredBy = [ "docker-hermes.service" ];
    path = [ config.virtualisation.docker.package ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker network inspect ${network} >/dev/null 2>&1 \
        || docker network create --subnet ${subnet} ${network}
      ${egressRules "-I"}
    '';
    preStop = egressRules "-D";
  };
}
