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
    openai = {
      url = "github:openai/skills";
      flake = false;
    };
    vercel-labs = {
      url = "github:vercel-labs/agent-skills";
      flake = false;
    };
  };

  outputs = { agent-skills-nix, ... }@inputs: {
    homeManagerModules.upstream = agent-skills-nix.homeManagerModules.default;
    homeManagerModules.config = { config, lib, hostName, ... }:
      let
        # SKILL.md を含む直下のサブディレクトリ名を列挙
        discoverSkills = root: subdir:
          let
            target = if subdir == null || subdir == "" then root else "${root}/${subdir}";
            entries = builtins.readDir target;
          in
          builtins.attrNames (lib.filterAttrs
            (n: v:
              (v == "directory" || v == "symlink")
              && builtins.pathExists "${target}/${n}/SKILL.md"
            )
            entries);

        # 手動列挙する source (curated; 旧 skills.enable 相当)
        # 同名 skill (例: anthropic/pdf vs openai/pdf) との discover 衝突を防ぐため、
        # 後段で sources.<name>.filter.nameRegex にも適用する。
        curatedSkills = {
          anthropic = [
            "algorithmic-art"
            "canvas-design"
            "claude-api"
            "doc-coauthoring"
            "frontend-design"
            "mcp-builder"
            "web-artifacts-builder"
            "skill-creator"
            "webapp-testing"
          ];
          openai = [
            "define-goal"
            "gh-address-comments"
            "gh-fix-ci"
            "jupyter-notebook"
            "playwright-interactive"
            "playwright"
            "security-best-practices"
            "security-ownership-map"
            "security-threat-model"
          ];
          vercel-labs = [
            "composition-patterns"
            "react-best-practices"
            "react-view-transitions"
            "web-design-guidelines"
          ];
        };

        # 全件 enable する source (旧 skills.enableAll 相当)
        discoveredSkills = {
          adr = discoverSkills inputs.adr.outPath "skills";
          google = discoverSkills inputs.google.outPath "skills/cloud";
        } // lib.optionalAttrs (hostName == "arpeggio") {
          gx-agent-recipes = discoverSkills
            "${config.home.homeDirectory}/ghq/github.com/groove-x/gx-agent-recipes"
            "skills";
        };

        # skills.explicit 構築用 (curated + discovered)
        prefixedSkills = curatedSkills // discoveredSkills;

        mkPrefixed = source: skillName: lib.nameValuePair "${source}.${skillName}" {
          from = source;
          path = skillName;
          rename = "${source}.${skillName}";
        };

        # 列挙された skill 名のみマッチする正規表現を生成
        # builtins.match は完全一致を要求するためアンカー不要
        toNameRegex = names: "(" + lib.concatStringsSep "|" names + ")";
      in
      {
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
              filter.nameRegex = toNameRegex curatedSkills.anthropic;
            };
            google = {
              path = inputs.google.outPath;
              subdir = "skills/cloud";
            };
            openai = {
              path = inputs.openai.outPath;
              subdir = "skills/.curated";
              filter.nameRegex = toNameRegex curatedSkills.openai;
            };
            vercel-labs = {
              path = inputs.vercel-labs.outPath;
              subdir = "skills";
              filter.nameRegex = toNameRegex curatedSkills.vercel-labs;
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

          # local skills は prefix なしで全件展開
          skills.enableAll = [ "local" ];

          # 外部 source は <source>.<skill-name> 形式に rename して
          # ~/.claude/skills/ 直下 (深さ1) に配置する。
          skills.explicit = lib.listToAttrs (lib.concatLists (
            lib.mapAttrsToList
              (source: skills: map (mkPrefixed source) skills)
              prefixedSkills
          ));

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
