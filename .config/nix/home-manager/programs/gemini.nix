{ pkgs, inputs, ... }:
let
  inherit (inputs) mcp-servers-nix;
  enableCodex = false;
in
{
  programs.gemini-cli = {
    enable = true;
    package = pkgs.llm-agents.gemini-cli;
    context = { GEMINI = "../../../agents/AGENTS.md"; };
    settings = {
      theme = "light";
      preferredEditor = "nvim";
      selectedAuthType = "oauth-personal";
      general = {
        disableAutoUpdate = true;
        disableUpdateNag = true;
      };
      mcpServers = import ./mcp-servers { inherit pkgs mcp-servers-nix enableCodex; };
    };
  };
}
