# Claude Code のレート制限を5分ごとに記録する。
# cc-statusline は全ホストに配られるため触らず、enigma だけがこのファイルを import する。
{ pkgs, username, ... }: {
  # node_exporter の textfile collector が読む置き場。
  # 書くのは User=username の dump サービス、読むのは exporter なので world-readable でよい
  systemd.tmpfiles.rules = [
    "d /var/lib/node-exporter-textfile 0755 ${username} users -"
  ];

  # enigma の exporter 定義は prometheus-exporters.nix 側だが、
  # textfile を読ませる理由はこのファイルなのでフラグはここで足す (NixOS はマージする)
  services.prometheus.exporters.node.extraFlags = [
    "--collector.textfile.directory=/var/lib/node-exporter-textfile"
  ];

  systemd.services.claude-usage-dump = {
    description = "Record Claude Code rate limit windows";

    # ネットワークが上がる前に起動して無駄に失敗するのを避ける
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = username;
      # uv のキャッシュ位置を確定させるため、systemd 任せにせず明示する
      Environment = [ "HOME=/home/${username}" ];
      ExecStart = "${pkgs.uv}/bin/uv run --script /home/${username}/dotfiles/bin/claude-usage-dump";
    };
  };

  systemd.timers.claude-usage-dump = {
    description = "Timer for Claude Code rate limit recording";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # 5分ごとの正時に揃えて等間隔の時系列にする
      OnCalendar = "*:0/5";
      # サスペンドから復帰したとき、取りこぼした分を1回だけ実行する
      Persistent = true;
    };
  };
}
