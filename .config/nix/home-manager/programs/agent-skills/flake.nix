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

    homeManagerModules.config = { config, ... }: {
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
        };

        skills.enableAll = [ "local" ];
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
        };
      };
    };
  };
}