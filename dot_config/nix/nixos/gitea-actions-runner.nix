# Gitea Actions Runner
# 登録先: bassoon (192.168.8.4) の Gitea
#
# 接続は Cloudflare Tunnel / nginx (8081) を経由せず Gitea 直 (3000)。
# nginx 経由にすると、Gitea が artifact の URL を「リクエストの Host + X-Forwarded-Proto」
# から組み立てる (modules/httplib/url.go GuessCurrentHostURL, PUBLIC_URL_DETECTION 既定 "auto")
# ため、hosts/bassoon/gitea.nix の `proxy_set_header X-Forwarded-Proto https` が効いて
# https://192.168.8.4:8081/... という到達不能な URL が返り artifact が壊れる。
{ config, pkgs, ... }:
let
  target = "192.168.8.4";
  giteaUrl = "http://${target}:3000";

  # 手置き。中身は `TOKEN=<registration token>` の 1 行。
  # StateDirectory (/var/lib/private/gitea-runner) とは別ディレクトリにすること。
  tokenFile = "/var/lib/gitea-actions-runner/env";

  # ジョブコンテナから到達できる enigma の LAN IP。
  # 空にすると自動検出だが tailscale0 のアドレスを拾いうるので固定する。
  cacheHost = "192.168.8.6";

  # Renovate {{{
  docker = "${config.virtualisation.docker.package}/bin/docker";

  # slim (= Node だけ) の方。-full は主要マネージャ同梱だが数GB あり、
  # しかも Dockerfile 側で RENOVATE_BINARY_SOURCE=global が固定されるので使わない。
  renovateImage = "ghcr.io/renovatebot/renovate:44";

  # イメージの実行 uid (tools/docker/Dockerfile の `USER 12021`)。
  # bind mount する state dir をこの uid が書けないと起動直後に落ちる。
  renovateUid = 12021;

  renovateStateDir = "/var/lib/renovate";

  renovateConfig = (pkgs.formats.json { }).generate "renovate-config.json" {
    platform = "gitea";
    endpoint = "${giteaUrl}/api/v1";
    autodiscover = true;
    autodiscoverNamespaces = [ "pava" ];
    gitAuthor = "Renovate Bot <renovate@localhost>";
    hostRules = [
      { hostType = "gitea"; matchHost = target; allowInternal = true; }
    ];

    # 本体。lock 更新に要る uv / npm 等を実行時に自動取得する。
    # Containerbase 環境 (= 公式イメージ) 以外では黙って global に落ちるので、
    # nixpkgs の services.renovate では機能しない。
    binarySource = "install";

    # 下の bind mount 先。ツールの DL キャッシュもここに残し毎回の再取得を避ける。
    baseDir = "/tmp/renovate";
    cacheDir = "/tmp/renovate/cache";
    containerbaseDir = "/tmp/renovate/containerbase";
  };
  # }}}
in
{
  # Renovate service {{
  # nixpkgs の services.renovate (素の node アプリ) ではなく公式コンテナで動かす。
  # モジュール版は Containerbase 環境でないため binarySource=install が global に
  # フォールバックし、`uv lock` が `spawn uv ENOENT` で失敗する。PR 自体は作られる
  # ので、pyproject.toml だけ更新され uv.lock が置き去りの PR が量産される。
  # 公式イメージなら言語ツールを実行時に調達するので、新しい言語が増えても設定不要。
  #
  # token は Nix store に入れず、ホスト上に手置きする (2 ファイルとも生の token 1 行)。
  # `sudo install -o root -g root -m 0400 /path/to/token /etc/renovate/token`
  # `sudo install -o root -g root -m 0400 /path/to/token /etc/renovate/github_com_token`
  systemd.services.renovate = {
    description = "Renovate dependency updater";
    documentation = [ "https://docs.renovatebot.com/" ];
    requires = [ "docker.service" ];
    after = [
      "docker.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
    startAt = "hourly";
    path = [
      pkgs.coreutils
      config.virtualisation.docker.package
    ];

    # docker は --env-file に `KEY=value` 形式しか取れないので、手置きの token から
    # tmpfs (RuntimeDirectory, 0700) 上に組み立てる。永続ファイルには落とさない。
    preStart = ''
      umask 077
      {
        printf 'RENOVATE_TOKEN=%s\n' "$(cat /etc/renovate/token)"
        printf 'RENOVATE_GITHUB_COM_TOKEN=%s\n' "$(cat /etc/renovate/github_com_token)"
      } > "$RUNTIME_DIRECTORY/env"

      # tag 内で image が動くので追従する。ネット断で実行ごと落とさない。
      docker pull ${renovateImage} || :
    '';

    script = ''
      exec ${docker} run --rm --name renovate \
        --env-file "$RUNTIME_DIRECTORY/env" \
        -e RENOVATE_CONFIG_FILE=/etc/renovate-config.json \
        -v ${renovateConfig}:/etc/renovate-config.json:ro \
        -v ${renovateStateDir}:/tmp/renovate \
        ${renovateImage}
    '';

    serviceConfig = {
      Type = "oneshot";
      RuntimeDirectory = "renovate";
      RuntimeDirectoryMode = "0700";

      # 初回はツールの DL が入るので長めに取る。
      TimeoutStartSec = "1h";

      # script が途中で失敗したときの掃除 (--rm が効かないケース用)。
      ExecStopPost = "-${docker} rm -f renovate";
    };
  };
  # }}

  # Runner instance {{{
  # unit: gitea-runner-enigma.service / state: /var/lib/private/gitea-runner/enigma
  services.gitea-actions-runner.instances.${config.networking.hostName} = {
    enable = true;
    name = config.networking.hostName;
    url = giteaUrl;
    inherit tokenFile;

    # ":docker:" を含むので SupplementaryGroups = [ "docker" ] が自動付与される。
    # 変更すると .labels の差分で再登録が走り、新しい登録トークンが要る。
    labels = [
      "ubuntu-latest:docker://docker.gitea.com/runner-images:ubuntu-latest"
      "ubuntu-24.04:docker://docker.gitea.com/runner-images:ubuntu-24.04"
      "ubuntu-22.04:docker://docker.gitea.com/runner-images:ubuntu-22.04"
    ];

    # NOTE: runner.labels は書かないこと。config.yaml 側の labels が register の
    #       --labels より優先され、モジュールの .labels 追跡とズレる。
    settings = {
      log.level = "info";

      # container.network が空 = ジョブごとに docker network を自動作成し、
      # daemon の address pool からサブネットを取るので capacity は控えめに。
      runner.capacity = 2;

      # 自動検出が tailscale0 を拾うのを防ぐ (0.0.0.0 は指定不可)
      cache.host = cacheHost;
    };
  };
  # }}}

  # Registration token (手置き) {{{
  # ディレクトリのみ用意し、トークン本体は tmpfiles に書かせない
  # (f で書くと Nix store 経由で world-readable になる)。
  systemd.tmpfiles.rules = [
    "d /var/lib/gitea-actions-runner 0700 root root - -"

    # Renovate の state (clone + cache + ツール置き場)。コンテナの bind mount 元。
    # docker に作らせると root:root 0755 になりコンテナ内 uid が書けないので、
    # ここで先に所有者を確定させる。
    "d ${renovateStateDir} 0700 ${toString renovateUid} ${toString renovateUid} - -"
  ];
  # }}}
}
