{ pkgs }: {
  command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
  args = [ "mcp-remote" "https://www.wrike.com/app/mcp/sse" "--header" "Authorization:$AUTH_HEADER" ];
  envFile = ../../../../../wrike-mcp-server;
}
