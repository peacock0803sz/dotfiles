{ pkgs, hostName }:
if hostName == "arpeggio" then {
  command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
  args = [
    "mcp-remote"
    "https://www.wrike.com/app/mcp/sse"
    "--header"
    "Authorization:Bearer \${WRIKE_API_TOKEN}"
  ];
  passwordCommand = "echo WRIKE_API_TOKEN=$WRIKE_API_TOKEN";
} else { enable = false; }
