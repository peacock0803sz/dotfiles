{ pkgs, npmPkgs, mcp-servers-nix, ... }:
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
      feedbackSurveyState.lastShownTime = 1754089004345;
      outputStyle = "Explanatory";

      permissions = {
        deny = [
          "Bash(rm -rf /*)"
          "Bash(rm -rf /)"
          "Bash(sudo rm -:*)"
          "Bash(chmod 777 /*)"
          "Bash(chmod -R 777 /*)"
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
          "Bash(nc -l -:*)"
          "Bash(ncat -l -:*)"
          "Bash(netcat -l -:*)"
          "Bash(rm -rf ~:*)"
          "Bash(rm -rf $HOME:*)"
          "Bash(rm -rf ~/.ssh*)"
          "Bash(rm -rf ~/.config*)"
          "Bash(npm)"
          "Bash(uv)"
        ];
      };
    };

    mcpServers = (mcp-servers-nix.lib.evalModule pkgs {
      programs = {
        codex.enable = true;
        # gemini.enable = true;
        serena = {
          enable = true;
          args = [
            "--context"
            "ide-assistant"
            "--enable-web-dashboard"
            "False"
          ];
        };
        context7.enable = true;
        playwright.enable = true;
        terraform.enable = true;
        nixos.enable = true;
      };
    }).config.settings.servers;
  };
}
