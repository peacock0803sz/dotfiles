{ pkgs, npmPkgs, mcp-servers-nix, ... }:
let
  config = mcp-servers-nix.lib.mkConfig pkgs {
    flavor = "codex";
    format = "toml-inline";
    fileName = ".mcp.toml";
    programs = {
      context7.enable = true;
      playwright.enable = true;
      terraform.enable = true;
      nixos.enable = true;
      serena = {
        enable = true;
        args = [
          "--context"
          "ide-assistant"
          "--enable-web-dashboard"
          "False"
        ];
      };
    };
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
