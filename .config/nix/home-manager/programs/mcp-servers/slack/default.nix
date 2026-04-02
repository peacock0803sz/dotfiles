{ pkgs }: {
  command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
  args = [ "@modelcontextprotocol/server-slack" ];
  passwordCommand = "echo SLACK_BOT_TOKEN=$SLACK_BOT_TOKEN SLACK_TEAM_ID=$SLACK_TEAM_ID";
}
