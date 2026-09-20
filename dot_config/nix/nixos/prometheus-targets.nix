# Prometheus の収集対象。exporter を立てる側 (被収集ホスト) と
# scrapeConfigs を書く側 (bassoon) の両方から import する単一の情報源。
# モジュールではなく素の attrset なので imports ではなく import で読む。
#
# 片側だけポートを変えると収集が静かに止まるので、必ずここを直すこと。
{
  bassoon = {
    # Prometheus と同居しているのでループバックで足りる
    address = "127.0.0.1";
    ports.node = 9100;
  };

  enigma = {
    # firewall が無効なので bind 先がそのまま露出範囲になる。
    # tailscale0 に出さないよう LAN IP を固定する
    # (DHCP だが 192.168.8.6 で予約済み。gitea-actions-runner.nix の cacheHost と同じ)
    address = "192.168.8.6";
    ports = {
      node = 9100;
      nvidia = 9835;
      # cAdvisor の既定は 8080 だが、enigma は docker ホストなので
      # コンテナが 8080 を publish して衝突しうる。ずらしておく
      cadvisor = 9101;
    };
  };

  overture = {
    # Raspberry Pi 4。enigma と同じく tailscale0 には出さず LAN IP に bind する
    # (DHCP だが 192.168.8.5 で予約済み)
    address = "192.168.8.5";
    # docker を入れていないので cadvisor はない。GPU もないので nvidia もない。
    # ここに port を書いていない exporter は立たず、収集対象にもならない
    ports.node = 9100;
  };
}
