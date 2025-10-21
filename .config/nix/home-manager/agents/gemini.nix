{ pkgs, npmPkgs, mcp-servers-nix, ... }:
{
  programs.gemini-cli = {
    enable = true;
    package = npmPkgs."@google/gemini-cli";
  };
}
