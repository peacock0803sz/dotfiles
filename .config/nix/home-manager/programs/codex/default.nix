{ pkgs, npmPkgs, mcp-servers-nix, ... }:
let
  enableCodex = false;
  config = mcp-servers-nix.lib.mkConfig pkgs {
    flavor = "codex";
    format = "toml-inline";
    fileName = ".mcp.toml";
    programs = import ../mcp-servers/programs.nix { inherit pkgs mcp-servers-nix enableCodex; };
  };
in
{
  programs.codex = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "codex";
      paths = [ npmPkgs."@openai/codex" ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/codex "--add-flags" "-c '$(cat ${config})'"
      '';
      custom-instructions = builtins.readFile ../../../../agents/AGENTS.md;
    };
    settings = {
      model_reasoning_summary = "auto";
      network_access = true;
      approval_policy = "never";
      sandbox_mode = "danger-full-access";
      trust_level = "trusted";
      model_reasoning_effort = "high";
      tools.web_search = true;
    };
  };
}
