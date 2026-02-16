{
  description = "Agent Skills Nix Configuration";

  inputs = {
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";
    anthropic = {
      url = "github:anthropics/skills";
      flake = false;
    };
    vercel = {
      url = "github:vercel-labs/agent-skills";
      flake = false;
    };
  };

  outputs = { agent-skills-nix, ... }@inputs: {
    homeManagerModules.upstream = agent-skills-nix.homeManagerModules.default;

    homeManagerModules.config = { config, lib, hostName, ... }: {
      programs.agent-skills = {
        enable = true;

        sources = {
          anthropic = {
            path = inputs.anthropic.outPath;
            subdir = "skills";
          };
          vercel-labs = {
            path = inputs.vercel.outPath;
            subdir = "skills";
          };
          local = {
            path = "${config.home.homeDirectory}/dotfiles/.config/agents/local-skills";
          };
        } // lib.optionalAttrs (hostName == "arpeggio") {
          gx-agent-recipes = {
            path = "${config.home.homeDirectory}/ghq/github.com/groove-x/gx-agent-recipes";
            subdir = "skills";
          };
        };

        skills.enableAll = [ "local" ]
          ++ lib.optional (hostName == "arpeggio") "gx-agent-recipes";
        skills.enable = [
          "frontend-design"
          "skill-creator"
          "webapp-testing"

          "composition-patterns"
          "react-best-practices"
          "web-design-guidelines"
        ];

        targets = {
          claude = {
            dest = ".claude/skills";
            structure = "link";
          };
          codex = {
            dest = ".codex/skills";
            structure = "link";
          };
        };
      };
    };
  };
}
