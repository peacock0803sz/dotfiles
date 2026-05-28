{ pkgs }: {
  command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
  args = [
    "mcp-remote"
    "https://mcp.devin.ai/mcp"
    "--header"
    "Authorization:Bearer \${DEVIN_API_KEY}"
    "--header"
    "X-Org-Id:\${DEVIN_ORG_ID}"
  ];
  passwordCommand = "echo DEVIN_API_KEY=$DEVIN_API_KEY && echo DEVIN_ORG_ID=$DEVIN_ORG_ID";
}
