{ pkgs, config, hostName, mcp-servers-nix, ... }:
let
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
    ".claude/skills".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/agents/skills";
    ".claude/rules".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/agents/rules";
    ".claude/commands".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/agents/commands";
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    memory.source = ../../../agents/AGENTS.md;

    settings = {
      theme = "dark";
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
          "Bash(sudo -:*)"
          "Bash(chmod -:*)"
          "Bash(dd if=:*)"
          "Bash(mkfs.:*)"
          "Bash(fdisk -:*)"
          "Bash(format -:*)"
          "Bash(shutdown -:*)"
          "Bash(reboot -:*)"
          "Bash(halt -:*)"
          "Bash(poweroff -:*)"
          "Bash(killall -:*)"
          "Bash(pkill -:*)"
          "Bash(ps -:*)"
          "Bash(nc -l -:*)"
          "Bash(ncat -l -:*)"
          "Bash(netcat -l -:*)"
          "Bash(docker -:*)"
        ];
      };

      enabledPlugins = {
        "gopls-lsp@claude-plugins-official" = true;
        "lua-lsp@claude-plugins-official" = true;
        "pyright-lsp@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
      };
    };

    mcpServers = mcp-servers // (if hostName == "arpeggio" then {
      wrike = (import ./mcp-servers/wrike { inherit pkgs; });
    } else { });
  };
}
