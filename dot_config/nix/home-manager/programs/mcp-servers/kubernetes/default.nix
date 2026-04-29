{ pkgs }: {
  command = "${pkgs.lib.getExe' pkgs.nodejs "npx"}";
  args = [ "-y" "kubernetes-mcp-server@latest" ];
}

