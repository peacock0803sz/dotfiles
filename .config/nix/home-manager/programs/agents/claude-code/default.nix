{ pkgs, npmPkgs, mcp-servers-nix, ... }:
let
  enableCodex = true;
  mcp-servers = import ../../mcp-servers { inherit pkgs mcp-servers-nix enableCodex; };
in
{
  programs.claude-code = {
    enable = true;
    package = npmPkgs."@anthropic-ai/claude-code";
    memory.source = ../AGENTS.md;

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
          "Bash(npm -:*)"
          "Bash(uv -:*)"
        ];
      };

      hooks = {
        PostToolUse = [
          { matcher = "Write"; hooks = [{ type = "command"; command = "${./hooks/plan-timestamp.py}"; }]; }
        ];
      };
    };
    mcpServers = mcp-servers // { zen = (import ../../mcp-servers/zen { inherit pkgs; }); };
  };
}
