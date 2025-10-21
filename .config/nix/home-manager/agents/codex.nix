{ pkgs, npmPkgs, mcp-servers-nix, ... }:
{
  programs.codex = {
    enable = true;
    package = npmPkgs."@openai/codex";
  };
}
