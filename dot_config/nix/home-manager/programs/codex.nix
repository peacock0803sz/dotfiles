{ pkgs, inputs, llm-agents, hostName, ... }:
let
  inherit (inputs) mcp-servers-nix;
  config = mcp-servers-nix.lib.mkConfig pkgs {
    flavor = "codex";
    format = "toml-inline";
    fileName = ".mcp.toml";
    programs = import ./mcp-servers/programs.nix { inherit pkgs mcp-servers-nix; };
    settings.servers = {
      kubernetes = import ./mcp-servers/kubernetes { inherit pkgs; };
      git_p3ac0ck_net = (import ./mcp-servers/gitea {
        inherit pkgs;
        host = "https://git.p3ac0ck.net";
        tokenSuffix = "git_p3ac0ck_net";
      });
    } // (if hostName == "arpeggio" then {
      devin = (import ./mcp-servers/devin { inherit pkgs; });
      # esa = (import ./mcp-servers/esa { inherit pkgs; });
      gcloud = (import ./mcp-servers/gcloud { inherit pkgs; });
      gitea_groove-x_io = (import ./mcp-servers/gitea {
        inherit pkgs;
        host = "https://gitea.groove-x.io";
        tokenSuffix = "gitea_groove_x_io";
      });
      lovot = (import ./mcp-servers/lovot { inherit pkgs; });
      # wrike = (import ./mcp-servers/wrike { inherit pkgs; });
      # slack = (import ./mcp-servers/slack { inherit pkgs; });
    } else { });
  };
in
{
  programs.codex = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "codex";
      paths = [ llm-agents.codex ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/codex "--add-flags" "-c '$(cat ${config})'"
      '';
      custom-instructions = builtins.readFile ../../../agents/AGENTS.md;
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
