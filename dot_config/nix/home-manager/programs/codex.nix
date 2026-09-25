{ pkgs, lib, config, inputs, llm-agents, hostName, ... }:
let
  inherit (inputs) mcp-servers-nix;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;

  # Top Shelf (Bartender) の AgentStatus ブリッジは macOS でしか動かない
  notchbarEnabled = pkgs.stdenv.isDarwin;
  notchbarHook = state: [{
    hooks = [{ type = "command"; command = "~/.codex/notchbar-event Codex ${state}"; }];
  }];

  # settings.servers は freeform なので passwordCommand はラッパーに変換されない。
  # GUI から起動した Codex にも認証情報を渡せるよう、MCP の起動時に読み込む。
  withSecrets = name: beforeExec: server:
    (lib.removeAttrs server [ "passwordCommand" ]) // {
      command = lib.getExe (pkgs.writeShellScriptBin "codex-mcp-${name}" ''
        exec ${lib.getExe pkgs.fish} -c '
          if test -f "$HOME/dotfiles/dot_config/fish/secrets.fish"
            source "$HOME/dotfiles/dot_config/fish/secrets.fish"
          end
          ${beforeExec}
          exec $argv
        ' -- ${lib.escapeShellArg server.command} "$@"
      '');
    };

  mcpConfig = mcp-servers-nix.lib.mkConfig pkgs {
    flavor = "codex";
    format = "toml-inline";
    fileName = ".mcp.toml";
    programs = import ./mcp-servers/programs.nix { inherit pkgs mcp-servers-nix; };
    settings.servers = {
      kubernetes = import ./mcp-servers/kubernetes { inherit pkgs; };
      git_p3ac0ck_net = withSecrets "git-p3ac0ck-net" "" (import ./mcp-servers/gitea {
        inherit pkgs;
        host = "https://git.p3ac0ck.net";
        tokenSuffix = "git_p3ac0ck_net";
      });
    } // (if hostName == "arpeggio" then {
      devin = withSecrets "devin" "" (import ./mcp-servers/devin { inherit pkgs; });
      esa = withSecrets "esa" "" (import ./mcp-servers/esa { inherit pkgs; });
      gcloud = (import ./mcp-servers/gcloud { inherit pkgs; });
      gitea_groove-x_io = withSecrets "gitea-groove-x-io" "" (import ./mcp-servers/gitea {
        inherit pkgs;
        host = "https://gitea.groove-x.io";
        tokenSuffix = "gitea_groove_x_io";
      });
      lovot = (import ./mcp-servers/lovot { inherit pkgs; });
      wrike = withSecrets "wrike" ''set argv[-1] "Authorization:Bearer $WRIKE_API_TOKEN"''
        (import ./mcp-servers/wrike { inherit pkgs; });
      slack = withSecrets "slack" "" (import ./mcp-servers/slack { inherit pkgs; });
    } else { });
  };
in
{
  home.file = lib.optionalAttrs notchbarEnabled
    {
      ".codex/notchbar-event".source =
        mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/agents/scripts/notchbar-event";
      ".codex/hooks.json".text = builtins.toJSON {
        hooks = {
          SessionStart = notchbarHook "Idle";
          UserPromptSubmit = notchbarHook "Working";
          PreToolUse = notchbarHook "Working";
          PostToolUse = notchbarHook "Auto";
          PermissionRequest = notchbarHook "Waiting";
          Stop = notchbarHook "Idle";
          SessionEnd = notchbarHook "Ended";
        };
      };
    } // {
    # `codex app-server daemon` (shared agents) only starts from this fixed path.
    # Point at the profile link rather than a /nix/store hash so the daemon follows
    # each Home Manager generation after a `home-manager switch`.
    ".codex/packages/standalone/current/codex".source =
      mkOutOfStoreSymlink "${homeDirectory}/.nix-profile/bin/codex";
  };

  programs.codex = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "codex";
      paths = [ llm-agents.codex ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/codex "--add-flags" "-c '$(cat ${mcpConfig})'"
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
