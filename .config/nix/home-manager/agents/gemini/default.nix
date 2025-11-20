# { pkgs, npmPkgs, mcp-servers-nix, ... }:
{ pkgs, ... }:
{
  programs.gemini-cli = {
    enable = true;
    # package = npmPkgs."@google/gemini-cli";
    package = pkgs.gemini-cli-bin;
    context = { GEMINI = "../AGENTS.md"; };
  };
}
