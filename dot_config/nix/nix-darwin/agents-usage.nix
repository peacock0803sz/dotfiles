# Codex / Claude Code のレート制限を5分ごとに bassoon の Pushgateway へ送る。
# kiosk-agents ダッシュボードが instance="arpeggio" の値を表示する。
# 取得・整形は enigma 用と同じ dump-usage/* を使い、出力先だけ環境変数で切り替える。
# Pushgateway の PUT はグループ単位で置き換えるため、Claude は agent ラベルでグループを分ける
{ pkgs, username, hostName, ... }:
let
  inherit ((import ../nixos/prometheus-targets.nix).bassoon) pushgateway;
  pushUrl = "http://${pushgateway.address}:${toString pushgateway.port}/metrics/job/agents-usage/instance/${hostName}";
  usageDump = name: env: {
    serviceConfig = {
      EnvironmentVariables = { HOME = "/Users/${username}"; } // env;
      ProgramArguments = [
        "${pkgs.uv}/bin/uv"
        "run"
        "--script"
        "/Users/${username}/dotfiles/dot_config/agents/scripts/dump-usage/${name}"
      ];
      StartInterval = 300; # every 5 minutes
      StandardErrorPath = "/tmp/${name}-usage-dump.err.log";
      StandardOutPath = "/tmp/${name}-usage-dump.out.log";
    };
  };
in
{
  launchd.user.agents.codex-usage-dump = usageDump "codex" {
    CODEX_USAGE_PUSH_URL = pushUrl;
  };
  launchd.user.agents.claude-usage-dump = usageDump "claude" {
    CLAUDE_USAGE_PUSH_URL = "${pushUrl}/agent/claude";
  };
}
