{
  description = "Agent Skills Nix Configuration";

  inputs = {
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";

    adr = {
      url = "github:drillan/adr-skills";
      flake = false;
    };
    anthropic = {
      url = "github:anthropics/skills";
      flake = false;
    };
    google = {
      url = "github:google/skills";
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
          adr = {
            path = inputs.adr.outPath;
            subdir = "skills";
          };
          anthropic = {
            path = inputs.anthropic.outPath;
            subdir = "skills";
          };
          google = {
            path = inputs.google.outPath;
            subdir = "skills/cloud";
          };
          vercel-labs = {
            path = inputs.vercel.outPath;
            subdir = "skills";
          };

          local = {
            path = "${config.home.homeDirectory}/dotfiles/dot_config/agents/local-skills";
          };
        } // lib.optionalAttrs (hostName == "arpeggio") {
          gx-agent-recipes = {
            path = "${config.home.homeDirectory}/ghq/github.com/groove-x/gx-agent-recipes";
            subdir = "skills";
          };
        };

        skills.enableAll = [ "local" "adr" "google" ]
          ++ lib.optional (hostName == "arpeggio") "gx-agent-recipes";
        skills.enable = [
          "algorithmic-art"
          "canvas-design"
          "claude-api"
          "doc-coauthoring"
          "frontend-design"
          "mcp-builder"
          "web-artifacts-builder"
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
          opencode = {
            dest = ".config/opencode/skills";
            structure = "link";
          };
        };
      };
    };
  };
}
