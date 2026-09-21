# AI エージェント系 CLI のレート制限を5分ごとに記録する。
# cc-statusline は全ホストに配られるため触らず、enigma だけがこのファイルを import する。
# - Claude Code: ~/.claude の OAuth token で api.anthropic.com/api/oauth/usage を叩く
# - Codex: ~/.codex の ChatGPT OAuth token で chatgpt.com/backend-api/wham/usage を叩く
# - OpenCode: ~/.local/share/opencode/opencode.db からトークン/コストを集計する (limit は概念が無いため対象外)
# どちらも node_exporter の textfile 用に .prom を書き出し、Prometheus が既存の node job で収集する。
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

  systemd.services.codex-usage-dump = {
    description = "Record Codex rate limit windows";

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = username;
      Environment = [ "HOME=/home/${username}" ];
      ExecStart = "${pkgs.uv}/bin/uv run --script /home/${username}/dotfiles/bin/codex-usage-dump";
    };
  };

  systemd.timers.codex-usage-dump = {
    description = "Timer for Codex rate limit recording";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/5";
      Persistent = true;
    };
  };

  systemd.services.opencode-usage-dump = {
    description = "Record OpenCode token and cost usage";

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = username;
      Environment = [ "HOME=/home/${username}" ];
      ExecStart = "${pkgs.uv}/bin/uv run --script /home/${username}/dotfiles/bin/opencode-usage-dump";
    };
  };

  systemd.timers.opencode-usage-dump = {
    description = "Timer for OpenCode usage recording";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # コスト集計は緩やかな変化なので毎時で十分
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
