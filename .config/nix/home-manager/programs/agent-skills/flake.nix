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
    gx-agent-recipes = {
      # url = "git+ssh://git@github.com/groove-x/gx-agent-recipes";
      url = "github:groove-x/gx-agent-recipes";
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
          gx-agent-recipes = {
            # path = "${config.home.homeDirectory}/ghq/github.com/groove-x/gx-agent-recipes";
            path = inputs.gx-agent-recipes.outPath;
            subdir = "skills";
          };
        };

        skills.enableAll = [ "local" "gx-agent-recipes" ];
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
