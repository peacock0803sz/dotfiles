# bassoon に HDMI ディスプレイを繋いで Grafana を常時表示するサイネージ構成。
# 表示専用でありサーバ機能ではないので、grafana.nix とは分けてある。
{ config, pkgs, lib, kioskDashboardTag, ... }:
let
  # 同ホストの Grafana をループバックで引く。nginx と TLS と DNS を経由しないので、
  # 証明書失効や Cloudflare 障害や MagicDNS の不調があっても画面は映り続ける
  grafana = "http://127.0.0.1:3001";

  # k8s 形式 API では metadata.name がそのまま uid になるので、再生成しても
  # URL が変わらない。表示時間は各ダッシュボード側に焼いてあるため from/to は付けない
  playlistUid = "kiosk";
  url = "${grafana}/playlists/play/${playlistUid}";

  # Grafana の service account token。service account も playlist も provisioning に
  # 対応しないため宣言的に作れない。UI か API で発行して手置きする。
  # playlist を書き込むので Viewer では足りず Editor 以上が要る。
  # 存在しないと LoadCredential が失敗し cage-tty1 が起動を繰り返す
  tokenFile = "/var/lib/grafana-kiosk/token";

  # 巡回対象はタグで決まる。ホストを prometheus-targets.nix に足すと
  # kiosk-dashboards.nix が同じタグ付きのダッシュボードを生成するので、
  # この定義自体は二度と変更しなくてよい
  playlistDef = pkgs.writeText "kiosk-playlist.json" (builtins.toJSON {
    kind = "Playlist";
    apiVersion = "playlist.grafana.app/v0alpha1";
    metadata = { name = playlistUid; namespace = "default"; };
    spec = {
      title = "Kiosk";
      interval = "1m";
      items = [{ type = "dashboard_by_tag"; value = kioskDashboardTag; }];
    };
  });

  playlistSync = pkgs.writeShellScript "grafana-playlist-sync" ''
    set -eu
    api="${grafana}/apis/playlist.grafana.app/v0alpha1/namespaces/default/playlists"
    auth="Authorization: Bearer $(cat "$CREDENTIALS_DIRECTORY/token")"

    body=$(${pkgs.coreutils}/bin/mktemp)
    payload=$(${pkgs.coreutils}/bin/mktemp)
    trap '${pkgs.coreutils}/bin/rm -f "$body" "$payload"' EXIT

    # -f だと本文を捨ててしまい、journal に curl の終了コードしか残らない。
    # 無人で動くので、失敗時に理由が読めることを優先してステータスを自分で見る
    call() {
      ${pkgs.curl}/bin/curl -sS -o "$body" -w '%{http_code}' \
        -X "$1" -H "$auth" -H 'Content-Type: application/json' "''${@:3}" "$2"
    }

    # After=grafana.service はプロセス起動しか見ない。HTTP が listen するまで待つ。
    # ここを `curl && break` と書くと && リストの失敗が set -e に拾われ、
    # リトライせず即終了してしまう
    ready=no
    for _ in $(${pkgs.coreutils}/bin/seq 60); do
      if ${pkgs.curl}/bin/curl -sf -o /dev/null "${grafana}/api/health"; then
        ready=yes
        break
      fi
      ${pkgs.coreutils}/bin/sleep 2
    done
    if [ "$ready" != yes ]; then
      echo "grafana did not start listening within 120s" >&2
      exit 1
    fi

    code=$(call GET "$api/${playlistUid}")
    case "$code" in
      200)
        # k8s 形式の更新は resourceVersion による楽観ロックを要求する
        rv=$(${pkgs.jq}/bin/jq -r '.metadata.resourceVersion' < "$body")
        ${pkgs.jq}/bin/jq --arg rv "$rv" '.metadata.resourceVersion = $rv' ${playlistDef} > "$payload"
        code=$(call PUT "$api/${playlistUid}" --data-binary @"$payload")
        action=updated
        ;;
      404)
        code=$(call POST "$api" --data-binary @${playlistDef})
        action=created
        ;;
      *)
        echo "unexpected status $code while reading the playlist" >&2
        ${pkgs.coreutils}/bin/cat "$body" >&2
        exit 1
        ;;
    esac

    case "$code" in
      200 | 201)
        echo "playlist ${playlistUid} $action"
        ;;
      403)
        echo "playlist $action refused (403). the service account token needs Editor or above" >&2
        ${pkgs.coreutils}/bin/cat "$body" >&2
        exit 1
        ;;
      *)
        echo "playlist $action failed with status $code" >&2
        ${pkgs.coreutils}/bin/cat "$body" >&2
        exit 1
        ;;
    esac
  '';

  # services.cage.program は absolute path 型なので引数付き起動は包む必要がある。
  # トークンを argv に置くと ps で他ユーザから見えるため環境変数に入れる
  # (/proc/PID/environ は所有者しか読めない)
  kioskRunner = pkgs.writeShellScript "grafana-kiosk-run" ''
    set -eu
    KIOSK_APIKEY_APIKEY="$(cat "$CREDENTIALS_DIRECTORY/token")"
    export KIOSK_APIKEY_APIKEY
    exec ${pkgs.grafana-kiosk}/bin/grafana-kiosk
  '';
in
{
  # 表示専用アカウント。Chromium がプロファイルを書くので通常ユーザにして home を持たせる
  users.users.kiosk = {
    isNormalUser = true;
    group = "kiosk";
    # 画面に出るだけの口なのでログイン手段を与えない
    shell = "${pkgs.shadow}/bin/nologin";
  };
  users.groups.kiosk = { };

  # token の置き場。中身は手置きなのでディレクトリだけ用意する
  systemd.tmpfiles.rules = [
    "d /var/lib/grafana-kiosk 0700 root root -"
  ];

  # cage-tty1.service が生成される。getty@tty1 との Conflicts、nullok な PAM、
  # hardware.graphics.enable、graphical.target への切り替えはモジュール側が面倒を見る
  services.cage = {
    enable = true;
    user = "kiosk";
    program = kioskRunner;
    # 既定は false。URL やフラグを変えて rebuild しても画面が切り替わらず
    # 原因不明に見えるので、設定変更をそのまま反映させる
    restartIfChanged = true;
    environment = {
      KIOSK_URL = url;
      KIOSK_LOGIN_METHOD = "apikey";
      # プレイリスト URL であることを伝える。inactive=1 が付いて
      # 操作待ちに落ちず、すぐ巡回が始まる
      KIOSK_IS_PLAYLIST = "true";
      # full は ?kiosk=1 に対応する。tv だとトップナビが残る
      KIOSK_MODE = "full";
      KIOSK_BROWSER_PATH = "${pkgs.chromium}/bin/chromium";
      # Xwayland を経由させず cage に直接描かせる
      KIOSK_OZONE_PLATFORM = "wayland";
      # キーボードもマウスも繋がないので、入力デバイス0台でも起動させる
      WLR_LIBINPUT_NO_DEVICES = "1";
    };
  };

  # プレイリストは Nix の定義から API 経由で突き合わせる。provisioning が
  # 対応しないので DB 上の状態になるが、定義は git 側にあり毎回上書きされる
  systemd.services.grafana-playlist-sync = {
    description = "Reconcile the Grafana kiosk playlist from its Nix definition";
    after = [ "grafana.service" ];
    wants = [ "grafana.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      LoadCredential = [ "token:${tokenFile}" ];
      ExecStart = playlistSync;
    };
  };

  systemd.services.cage-tty1 = {
    # Grafana より先に開くとエラーページを掴んだまま止まる。
    # プレイリスト未作成のまま開くと 404 になるので sync の後に回す
    after = [ "grafana.service" "grafana-playlist-sync.service" "network-online.target" ];
    wants = [ "network-online.target" "grafana-playlist-sync.service" ];
    serviceConfig = {
      LoadCredential = [ "token:${tokenFile}" ];
      # モジュール側は Restart を設定しない。無人運用では落ちたら戻す必要がある
      Restart = "always";
      RestartSec = 10;
    };
  };

  # Grafana のキオスク表示は数時間から数日で Chrome タブが OOM する既知問題があり、
  # 上流に修正の保証がない。リロードで復旧するので毎日作り直して回収する
  systemd.timers.kiosk-restart = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "04:00";
  };
  systemd.services.kiosk-restart = {
    serviceConfig.Type = "oneshot";
    script = "${config.systemd.package}/bin/systemctl restart cage-tty1.service";
  };

  # カーネルコンソールのブランキングを止める。コンポジタとモニタ DPMS とは
  # 独立した層なので、これを残すと他を潰しても消灯する
  # ディスプレイを反時計回り90度で縦置きにする。video= の rotate は時計回り基準
  # なので反時計回り90度 = rotate=270。逆に倒れたら rotate=90 に変えること。
  # コネクタ名は実機の /sys/class/drm/ で確認する (HDMI-A-1 とは限らない)。
  # 解像度を固定したい場合は video=HDMI-A-1:1920x1080@60e,rotate=270 の形にする
  boot.kernelParams = [ "consoleblank=0" "video=HDMI-A-1:rotate=270" ];
}
