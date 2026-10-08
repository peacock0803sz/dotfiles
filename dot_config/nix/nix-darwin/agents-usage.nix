# Codex のレート制限を5分ごとに bassoon の Pushgateway へ送る。
# kiosk-agents ダッシュボードが instance="arpeggio" の値を表示する。
# 取得・整形は enigma 用と同じ dump-usage/codex を使い、出力先だけ環境変数で切り替える
{ pkgs, username, hostName, ... }:
let
  inherit ((import ../nixos/prometheus-targets.nix).bassoon) pushgateway;
in
{
  launchd.user.agents.codex-usage-dump = {
    serviceConfig = {
      EnvironmentVariables = {
        HOME = "/Users/${username}";
        CODEX_USAGE_PUSH_URL =
          "http://${pushgateway.address}:${toString pushgateway.port}/metrics/job/agents-usage/instance/${hostName}";
      };
      ProgramArguments = [
        "${pkgs.uv}/bin/uv"
        "run"
        "--script"
        "/Users/${username}/dotfiles/dot_config/agents/scripts/dump-usage/codex"
      ];
      StartInterval = 300; # every 5 minutes
      StandardErrorPath = "/tmp/codex-usage-dump.err.log";
      StandardOutPath = "/tmp/codex-usage-dump.out.log";
    };
  };
}
