{ pkgs }: {
  command = "${pkgs.lib.getExe' pkgs.uv "uvx"}";
  args = [ "--from" "git+https://github.com/BeehiveInnovations/zen-mcp-server.git" "zen-mcp-server" ];
  envFile = ../../../../../zen-mcp-server;
}
