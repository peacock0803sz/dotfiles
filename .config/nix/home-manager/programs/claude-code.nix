{ pkgs, config, hostName, inputs, ... }:
let
  inherit (inputs) mcp-servers-nix;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
  enableCodex = true;
  mcp-servers = import ./mcp-servers { inherit pkgs mcp-servers-nix enableCodex; };
in
{
  home.packages = with pkgs; [
    llm-agents.ccusage
    llm-agents.claude-code-acp
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
        ];
      };

      enabledPlugins = {
        "gopls-lsp@claude-plugins-official" = true;
        "lua-lsp@claude-plugins-official" = true;
        "pyright-lsp@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
        "atlassian@claude-plugins-official" = if hostName == "arpeggio" then true else false;
        "pr-review-toolkit@claude-plugins-official" = true;
        "feature-dev@claude-plugins-official" = true;
      };
    };

    mcpServers = mcp-servers // (if hostName == "arpeggio" then {
      esa = (import ./mcp-servers/esa { inherit pkgs; });
      wrike = (import ./mcp-servers/wrike { inherit pkgs; });
      slack = (import ./mcp-servers/slack { inherit pkgs; });
    } else { });
  };
}
