# 被収集ホスト (enigma) 用の exporter 一式。
# Prometheus 本体は立てない。収集は bassoon の nixos/grafana.nix が行う。
{ ... }:
let
  targets = import ./prometheus-targets.nix;
  inherit (targets.enigma) address ports;

  # exporter の汎用モジュールは after = [ "network.target" ] しか張らない。
  # enigma は networking.useDHCP なので LAN IP がまだ付いていない時刻に
  # bind が失敗しうる。Restart = "always" はあるが既定の start limit で
  # 諦めてしまうので、アドレスが確定する network-online.target まで待たせる
  waitForAddress = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
in
{
  services.prometheus.exporters = {
    node = {
      enable = true;
      listenAddress = address;
      port = ports.node;
      # 既定のコレクタ (cpu/meminfo/diskstats/filesystem/netdev/hwmon 等) への追加分。
      # bassoon 側と揃えてある
      enabledCollectors = [ "systemd" "processes" ];
    };

    # nvidia-smi のパス解決と PrivateDevices = false はモジュール側が
    # hardware.nvidia.package から面倒を見るので、ここでの権限設定は不要
    nvidia-gpu = {
      enable = true;
      listenAddress = address;
      port = ports.nvidia;
    };
  };

  services.cadvisor = {
    enable = true;
    listenAddress = address;
    port = ports.cadvisor;
  };

  systemd.services = {
    prometheus-node-exporter = waitForAddress;
    prometheus-nvidia-gpu-exporter = waitForAddress;
    # docker.service への依存はモジュール側が張り済み。
    # postStart が自分の listen アドレスへ curl が通るまで待ち
    # TimeoutStartSec = 300 なので、bind 失敗は 5 分のハングになる。
    # network-online を待たせる意味は他の exporter より大きい
    cadvisor = waitForAddress;
  };
}
