{ pkgs }: {
  command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
  args = [ "@esaio/esa-mcp-server" ];
  passwordCommand = "echo ESA_ACCESS_TOKEN=$ESA_ACCESS_TOKEN";
}
