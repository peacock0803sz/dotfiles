{
  description = "Agent Skills Nix Configuration";

  inputs = {
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";

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
    superpowers = {
      url = "github:obra/superpowers";
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
          google = [
            "gcloud"
            "bigquery-basics"
            "bigquery-ai-ml"
            "bigquery-bigframes"
            "bigquery-observability"
            "bigquery-slot-cost-optimizer"
            "datalineage-bigquery-asset-impact-analysis"
            "datalineage-summary"
            "dbt-sf-to-bq-translator"
            "gke-basics"
            "cloud-run-basics"
            "cloud-logging-query-generation"
            "cloud-monitoring-promql-query"
          ];
        };

        # google の残りは skill 一覧の予算 (context の約1%) を超えるため常駐させず、
        # どの agent も skill として走査しない共通の場所に置き、curated 側から Read で辿らせる。
        # `.agents/skills` は Codex や opencode が走査するので、別名の `skill-library` にしている。
        # agent-platform は使わないので置かない。
        googleLibraryDir = ".agents/skill-library/google";
        googleLibrary = lib.filter
          (n: !(lib.elem n curatedSkills.google) && !(lib.hasPrefix "agent-platform-" n))
          (discoverSkills inputs.google.outPath "skills/cloud");
        googleLibraryNote = ''

          ## 関連する Google Cloud skill

          本文や description で名前が出てくる他の Google Cloud skill(例: `gke-upgrades`)は Skill ツールでは呼べない。
          `~/${googleLibraryDir}/<name>/SKILL.md` を Read して、その指示に従う。
          名前が分からないときは `ls ~/${googleLibraryDir}` で一覧を見る。
        '';

        # 全件 enable する source (旧 skills.enableAll 相当)
        discoveredSkills = {
          superpowers = discoverSkills inputs.superpowers.outPath "skills";
        } // lib.optionalAttrs (hostName == "arpeggio") {
          gx-agent-recipes = discoverSkills
            "${config.home.homeDirectory}/ghq/github.com/groove-x/gx-agent-recipes"
            "skills";
        };

        # skills.explicit 構築用 (curated + discovered)
        prefixedSkills = curatedSkills // discoveredSkills;

        mkPrefixed = source: skillName: lib.nameValuePair "${source}.${skillName}" ({
          from = source;
          path = skillName;
          rename = "${source}.${skillName}";
        } // lib.optionalAttrs (source == "superpowers") {
          # 上流は Claude plugin 形式の ID (superpowers:brainstorming) で相互参照するため、
          # rename 後の配置名 (superpowers.brainstorming) に合わせて書き換える。
          transform = { original, ... }:
            builtins.replaceStrings [ "superpowers:" ] [ "superpowers." ] original;
        } // lib.optionalAttrs (source == "google") {
          transform = { original, ... }: original + googleLibraryNote;
        });

        # 列挙された skill 名のみマッチする正規表現を生成
        # builtins.match は完全一致を要求するためアンカー不要
        toNameRegex = names: "(" + lib.concatStringsSep "|" names + ")";
      in
      {
        home.file = lib.listToAttrs (map
          (n: lib.nameValuePair "${googleLibraryDir}/${n}" {
            source = "${inputs.google.outPath}/skills/cloud/${n}";
          })
          googleLibrary);

        programs.agent-skills = {
          enable = true;
          sources = {
            anthropic = {
              path = inputs.anthropic.outPath;
              subdir = "skills";
              filter.nameRegex = toNameRegex curatedSkills.anthropic;
            };
            google = {
              path = inputs.google.outPath;
              subdir = "skills/cloud";
              filter.nameRegex = toNameRegex curatedSkills.google;
            };
            openai = {
              path = inputs.openai.outPath;
              subdir = "skills/.curated";
              filter.nameRegex = toNameRegex curatedSkills.openai;
            };
            superpowers = {
              path = inputs.superpowers.outPath;
              subdir = "skills";
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
            pi = {
              dest = ".pi/agent/skills";
              structure = "link";
            };
          };
        };
      };
  };
}
