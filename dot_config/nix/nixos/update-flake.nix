# .github/workflows/update-nix.yml (update-flake.yml) の enigma 版。
# (dir, input) ごとに `nix flake update` して 1 コミットずつ積み、最後に master へ push する。
# 作業ツリーは ~/dotfiles と分けた専用 clone (/var/lib/update-flake/dotfiles) で、毎回 origin に揃える。
{ config, pkgs, username, ... }:
let
  repoUrl = "https://github.com/peacock0803sz/dotfiles.git";
  branch = "master";

  update-flake = pkgs.writeShellApplication {
    name = "update-flake";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gawk
      pkgs.git
      pkgs.jq
      pkgs.openssh
      config.nix.package
    ];
    # 引数: 対象 input 名 (空 = 全 input)
    text = ''
      repo="$STATE_DIRECTORY/dotfiles"
      if [[ ! -d "$repo/.git" ]]; then
        git clone ${repoUrl} "$repo"
      fi
      cd "$repo"
      git fetch origin ${branch}
      git checkout -B ${branch} origin/${branch}
      git reset --hard origin/${branch}

      allowed_types='["github","git","gitlab","sourcehut","tarball","path"]'

      # 子の path-input を親より先に更新・コミットするため、深い flake.lock から処理する
      while IFS= read -r dir; do
        lock="$dir/flake.lock"
        [[ -f "$lock" ]] || continue
        label="''${dir#./}"
        [[ "$label" == "." ]] && label="root"

        names=$(jq -r --argjson allowed "$allowed_types" '
          .nodes as $nodes
          | $nodes[.root].inputs
          | to_entries[]
          | .key as $name
          | (if (.value | type) == "string" then .value else .value[-1] end) as $node
          | select($allowed | index($nodes[$node].original.type))
          | $name
        ' "$lock")

        while IFS= read -r name; do
          [[ -z "$name" ]] && continue
          if (( $# > 0 )); then
            match=false
            for r in "$@"; do
              [[ "$r" == "$name" ]] && match=true && break
            done
            [[ "$match" == "true" ]] || continue
          fi

          (cd "$dir" && nix flake update "$name")
          if [[ -n "$(git status --untracked-files=no --short "$lock")" ]]; then
            git add "$lock"
            git commit -m "Update ''${label} flake.lock: ''${name}"
          fi
        done <<<"$names"
      done < <(find . -name flake.lock -not -path './.git/*' -printf '%h\n' | awk -F/ '{print NF, $0}' | sort -k1,1nr -k2 | cut -d' ' -f2-)

      if [[ -n "$(git log origin/${branch}..HEAD --oneline)" ]]; then
        git push origin HEAD:${branch}
      fi
    '';
  };

  mkService = description: args: {
    inherit description;
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = username;
      StateDirectory = "update-flake";
      ExecStart = "${update-flake}/bin/update-flake ${args}";
      TimeoutStartSec = "1h";
    };
    environment = {
      # push は ~/.gitconfig の gh auth git-credential、nix の access-tokens も ~ 配下を使う
      HOME = "/home/${username}";

      # signingkey が公開鍵リテラルなので agent 無しでは署名できない。
      # notizen-syncer と同じく秘密鍵ファイルを直接指す
      GIT_CONFIG_COUNT = "2";
      GIT_CONFIG_KEY_0 = "gpg.ssh.program";
      GIT_CONFIG_VALUE_0 = "${pkgs.openssh}/bin/ssh-keygen";
      GIT_CONFIG_KEY_1 = "user.signingkey";
      GIT_CONFIG_VALUE_1 = "/home/${username}/.ssh/id_ed25519";
    };
  };

  mkTimer = description: onCalendar: {
    inherit description;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = onCalendar;
      Persistent = true;
    };
  };
in
{
  systemd.services.update-flake-all = mkService "Update all flake inputs" "";
  systemd.timers.update-flake-all =
    mkTimer "Timer for updating all flake inputs" "*-*-* 06,18:00:00 Asia/Tokyo";

  systemd.services.update-flake-llm-agents = mkService "Update llm-agents flake input" "llm-agents";
  systemd.timers.update-flake-llm-agents =
    mkTimer "Timer for updating llm-agents flake input" "*-*-* 00,12:00:00 Asia/Tokyo";
}
