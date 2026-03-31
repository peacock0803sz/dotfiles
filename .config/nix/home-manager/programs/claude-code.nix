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
    ".claude/rules".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/agents/rules";
    ".claude/statusline".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/agents/scripts/statusline";
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    memory.source = ../../../agents/AGENTS.md;

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

    mcpServers = mcp-servers // (if hostName == "arpeggio" then {
      esa = (import ./mcp-servers/esa { inherit pkgs; });
    } else { });
  };
}
