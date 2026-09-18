# Gitea Actions Runner
# 登録先: bassoon (192.168.8.4) の Gitea
#
# 接続は Cloudflare Tunnel / nginx (8081) を経由せず Gitea 直 (3000)。
# nginx 経由にすると、Gitea が artifact の URL を「リクエストの Host + X-Forwarded-Proto」
# から組み立てる (modules/httplib/url.go GuessCurrentHostURL, PUBLIC_URL_DETECTION 既定 "auto")
# ため、hosts/bassoon/gitea.nix の `proxy_set_header X-Forwarded-Proto https` が効いて
# https://192.168.8.4:8081/... という到達不能な URL が返り artifact が壊れる。
{ config, ... }:
let
  target = "192.168.8.4";
  giteaUrl = "http://${target}:3000";

  # 手置き。中身は `TOKEN=<registration token>` の 1 行。
  # StateDirectory (/var/lib/private/gitea-runner) とは別ディレクトリにすること。
  tokenFile = "/var/lib/gitea-actions-runner/env";

  # ジョブコンテナから到達できる enigma の LAN IP。
  # 空にすると自動検出だが tailscale0 のアドレスを拾いうるので固定する。
  cacheHost = "192.168.8.6";
in
{
  # Renovate service {{
  # Gitea API tokenはNix storeに入れず、ホスト上に手置きする。
  # `sudo install -o root -g root -m 0400 /path/to/token /etc/renovate/token`
  services.renovate = {
    enable = true;
    schedule = "daily";
    credentials = {
      RENOVATE_TOKEN = "/etc/renovate/token";
      RENOVATE_GITHUB_COM_TOKEN = "/etc/renovate/github_com_token";
    };
    settings = {
      platform = "gitea";
      endpoint = "${giteaUrl}/api/v1";
      autodiscover = true;
      gitAuthor = "Renovate Bot <renovate@localhost>";
      autodiscoverNamespaces = [ "pava" ];
      hostRules = [
        { hostType = "gitea"; matchHost = target; allowInternal = true; }
      ];
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
  ];
  # }}}
}
