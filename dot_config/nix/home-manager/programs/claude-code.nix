{ pkgs, config, hostName, inputs, ... }:
let
  inherit (inputs) mcp-servers-nix;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
  mcp-servers = import ./mcp-servers { inherit pkgs mcp-servers-nix; };
in
{
  home.packages = with pkgs; [
    llm-agents.ccusage
  ];

  home.file = {
    ".claude/rules".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/agents/rules";
    ".claude/statusline".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/agents/scripts/statusline";
    ".claude/notify".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/agents/scripts/notify";
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    context = ../../../agents/AGENTS.md;

    settings = {
      theme = "light";
      autoUpdates = false;
      includeCoAuthoredBy = false;
      autoCompactEnabled = false;
      enableAllProjectMcpServers = true;
      outputStyle = "Explanatory";
      teammateMode = "in-process";
      statusLine = {
        type = "command";
        command = "~/.claude/statusline";
      };

      hooks = {
        Notification = [
          {
            matcher = "permission_prompt";
            hooks = [{ type = "command"; command = "~/.claude/notify 'Claude Code' 'Permission requested'"; }];
          }
          {
            matcher = "idle_prompt";
            hooks = [{ type = "command"; command = "~/.claude/notify 'Claude Code' 'Waiting for input'"; }];
          }
          {
            matcher = "elicitation_dialog";
            hooks = [{ type = "command"; command = "~/.claude/notify 'Claude Code' 'MCP needs input'"; }];
          }
        ];
      };

      permissions = {
        deny = [
          "Bash(rm -rf /*)"
          "Bash(rm -rf /)"
          "Bash(sudo *)"
          "Bash(chmod *)"
          "Bash(dd if=:*)"
          "Bash(mkfs.:*)"
          "Bash(fdisk *)"
          "Bash(format *)"
          "Bash(shutdown *)"
          "Bash(reboot *)"
          "Bash(halt *)"
          "Bash(poweroff *)"
          "Bash(killall *)"
          "Bash(pkill *)"
          "Bash(nc -l -:*)"
          "Bash(ncat -l -:*)"
          "Bash(netcat -l -:*)"
          "Bash(docker kill *)"
          "Bash(docker stop *)"
          "Bash(docker compose down)"
          "Bash(git -C *)"
          "Bash(git add .)"
          "Bash(git push -:*)"
          "Bash(git status --untracked-files=no -:*)"
          "Bash(.venv/bin/python -c)"
          "Bash(.venv/bin/python3 -c)"
          "Bash(python -c *)"
          "Bash(python3 -c *)"
          "Bash(uv run *)"
        ];
        allow = [
          "Bash(git log *)"
          "Bash(git diff *)"
          "Bash(git show *)"
          "Bash(git status --short --untracked-files)"
          "Bash(git add .*)"
          "Bash(git commit -m *)"
          "Bash(docker ps :*)"
          "Bash(docker compose ps :*)"
          "Bash(gh pr view *)"
          "Bash(gh run view *)"
          "Bash(jq -r)"
          "Bash(.venv/bin/ruff)"
          "Bash(.venv/bin/ty)"
          "Bash(.venv/bin/pytest)"
          "Bash(.venv/bin/python3 -m doctest *)"
        ];
      };

      extraKnownMarketplaces = {
        openai-codex = {
          source = {
            source = "github";
            repo = "openai/codex-plugin-cc";
          };
        };
      };
      enabledPlugins = {
        "atlassian@claude-plugins-official" = if hostName == "arpeggio" then true else false;
        "pr-review-toolkit@claude-plugins-official" = true;
        "feature-dev@claude-plugins-official" = true;
        "codex@openai-codex" = true;
      };
    };

    lspServers = {
      go = {
        command = "gopls";
        args = [ "serve" ];
        extensionToLanguage = {
          ".go" = "go";
        };
      };
      python = {
        command = "pyright-langserver";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".py" = "python";
        };
      };
      typescript = {
        command = "typescript-language-server";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".ts" = "typescript";
          ".tsx" = "typescriptreact";
          ".js" = "javascript";
          ".jsx" = "javascriptreact";
        };
      };
    };

    mcpServers = mcp-servers // {
      linear = (import ./mcp-servers/linear { inherit pkgs; });
    } // (if hostName == "arpeggio" then {
      gcloud = (import ./mcp-servers/gcloud { inherit pkgs; });
      esa = (import ./mcp-servers/esa { inherit pkgs; });
      wrike = (import ./mcp-servers/wrike { inherit pkgs; });
      slack = (import ./mcp-servers/slack { inherit pkgs; });
    } else { });
  };
}
