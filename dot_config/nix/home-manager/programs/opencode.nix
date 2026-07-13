{ pkgs, config, inputs, llm-agents, ... }:
let
  inherit (inputs) mcp-servers-nix;
  mcp-servers = import ./mcp-servers { inherit pkgs mcp-servers-nix; };
in
{
  programs.mcp = {
    enable = true;
    servers = mcp-servers;
  };

  programs.opencode = {
    enable = true;
    package = llm-agents.opencode;
    context = ../../../agents/AGENTS.md;
    enableMcpIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ./opencode/settings.json);
  };
}
