{ pkgs, npmPkgs, mcp-servers-nix, ... }:
{
  programs.claude-code = {
    enable = true;
    package = npmPkgs."@anthropic-ai/claude-code";
    memory.source = ./AGENTS.md;
    mcpServers = (mcp-servers-nix.lib.evalModule pkgs {
      programs = {
        context7.enable = true;
        playwright.enable = true;
        terraform.enable = true;
        nixos.enable = true;
      };
    }).config.settings.servers;
  };
}
