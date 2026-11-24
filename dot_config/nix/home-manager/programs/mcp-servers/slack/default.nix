# workspace: secrets.fish で export している `_SLACK_USER_TOKEN_<workspace>` の suffix
#
# Claude Code も Codex も passwordCommand を解釈しないため、起動ラッパーで
# suffix 付きの変数を server-slack が読む SLACK_BOT_TOKEN / SLACK_TEAM_ID に詰め替える。
# server-slack は SLACK_BOT_TOKEN しか読まないので、user token (xoxp-) をそこに渡す。
# 継承した SLACK_BOT_TOKEN には決してフォールバックしない (別 workspace に投稿しないため)。
{ pkgs, workspace }:
let
  inherit (pkgs) lib;
  wrapper = pkgs.writeShellScript "slack-mcp-${workspace}" ''
    set -euo pipefail
    token="''${_SLACK_USER_TOKEN_${workspace}:-}"
    if [ -z "$token" ]; then
      echo "slack-mcp: _SLACK_USER_TOKEN_${workspace} is not set" >&2
      exit 1
    fi
    # _SLACK_TEAM_ID_<workspace> が無ければトークン自身から team_id を引く
    team="''${_SLACK_TEAM_ID_${workspace}:-}"
    if [ -z "$team" ]; then
      team="$(${lib.getExe pkgs.curl} -fsS -H "Authorization: Bearer $token" https://slack.com/api/auth.test \
        | ${lib.getExe pkgs.jq} -r '.team_id // empty')"
    fi
    if [ -z "$team" ]; then
      echo "slack-mcp: could not resolve team id for ${workspace}" >&2
      exit 1
    fi
    export SLACK_BOT_TOKEN="$token" SLACK_TEAM_ID="$team"
    exec ${lib.getExe' pkgs.nodejs "npx"} "$@"
  '';
in
{
  command = "${wrapper}";
  args = [ "@modelcontextprotocol/server-slack" ];
}
