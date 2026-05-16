{ pkgs, config, inputs, ... }:
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
    package = pkgs.llm-agents.opencode;
    context = ../../../agents/AGENTS.md;
    enableMcpIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ./opencode/settings.json);
  };
}
