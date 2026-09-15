# Claude Code のレート制限を5分ごとに記録する。
# cc-statusline は全ホストに配られるため触らず、enigma だけがこのファイルを import する。
{ pkgs, username, ... }: {
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
