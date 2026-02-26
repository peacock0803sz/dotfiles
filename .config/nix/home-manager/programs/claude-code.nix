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
        command = "echo $(cat) | ccusage statusline";
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
          "Bash(ps *)"
          "Bash(nc -l -:*)"
          "Bash(ncat -l -:*)"
          "Bash(netcat -l -:*)"
          "Bash(docker *)"
          "Bash(git -C *)"
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
