{ pkgs, host, tokenSuffix }: {
  command = "${ pkgs.lib.getExe' pkgs.gitea-mcp-server "gitea-mcp" }";
  args = [ "-t" "stdio" "--host" host ];
  passwordCommand = "echo GITEA_ACCESS_TOKEN=$GITEA_ACCESS_TOKEN_${tokenSuffix}";
}
