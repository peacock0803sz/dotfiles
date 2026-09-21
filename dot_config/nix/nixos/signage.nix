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
  # 存在しないと LoadCredential が失敗し sway-kiosk が起動を繰り返す
  tokenFile = "/var/lib/grafana-kiosk/token";

  # 巡回対象はタグで決まる。ホストを prometheus-targets.nix に足すと
  # grafana-kiosk.nix が同じタグ付きのダッシュボードを生成するので、
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

  # 引数付き起動はスクリプトに包む。トークンを argv に置くと ps で他ユーザから
  # 見えるため環境変数に入れる (/proc/PID/environ は所有者しか読めない)
  kioskRunner = pkgs.writeShellScript "grafana-kiosk-run" ''
    set -eu
    KIOSK_APIKEY_APIKEY="$(cat "$CREDENTIALS_DIRECTORY/token")"
    export KIOSK_APIKEY_APIKEY
    exec ${pkgs.grafana-kiosk}/bin/grafana-kiosk
  '';

  # sway 用設定。HDMI-A-1 を反時計回り90度で縦置きにする。
  # 逆に倒れたら transform を 270 に変えること
  swayConfig = pkgs.writeText "sway-kiosk-config" ''
    output HDMI-A-1 transform 90
    exec ${kioskRunner}
    for_window [app_id=".*"] fullscreen enable
  '';

  # systemd unit の ExecStart にそのまま置けるよう包む
  swayRunner = pkgs.writeShellScript "sway-kiosk-start" ''
    exec ${pkgs.sway}/bin/sway --config ${swayConfig}
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

  # cage 0.3.1 に出力回転がないため sway で回す。cage-tty1 unit と同形の
  # 自前 unit (tty1 占有・nullok PAM・token の LoadCredential・自動再起動)
  # programs.sway はラッパー整備用で、デーモン等は起動しない
  programs.sway.enable = true;

  # cage モジュールが面倒を見ていた分を明示する
  hardware.graphics.enable = true;

  systemd.services.sway-kiosk = {
    description = "Sway kiosk for Grafana signage";
    # Grafana より先に開くとエラーページを掴んだまま止まる。
    # プレイリスト未作成のまま開くと 404 になるので sync の後に回す
    after = [ "systemd-user-sessions.service" "systemd-logind.service" "getty@tty1.service" "grafana.service" "grafana-playlist-sync.service" "network-online.target" ];
    wants = [ "systemd-logind.service" "network-online.target" "grafana-playlist-sync.service" ];
    conflicts = [ "getty@tty1.service" ];
    wantedBy = [ "graphical.target" ];
    environment = {
      KIOSK_URL = url;
      KIOSK_LOGIN_METHOD = "apikey";
      # プレイリスト URL であることを伝える。inactive=1 が付いて
      # 操作待ちに落ちず、すぐ巡回が始まる
      KIOSK_IS_PLAYLIST = "true";
      # full は ?kiosk=1 に対応する。tv だとトップナビが残る
      KIOSK_MODE = "full";
      KIOSK_BROWSER_PATH = "${pkgs.chromium}/bin/chromium";
      # Xwayland を経由させず sway に直接描かせる
      KIOSK_OZONE_PLATFORM = "wayland";
      # キーボードもマウスも繋がないので、入力デバイス0台でも起動させる
      WLR_LIBINPUT_NO_DEVICES = "1";
    };
    serviceConfig = {
      User = "kiosk";
      PAMName = "sway-kiosk";
      TTYPath = "/dev/tty1";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
      StandardInput = "tty-fail";
      StandardOutput = "journal";
      StandardError = "journal";
      UtmpIdentifier = "%n";
      UtmpMode = "user";
      LoadCredential = [ "token:${tokenFile}" ];
      # 無人運用では落ちたら戻す必要がある
      Restart = "always";
      RestartSec = 10;
      # sway も SIGTERM ではすぐ死なないため、switch のたびに待たされないよう短縮する
      TimeoutStopSec = "15s";
      ExecStart = swayRunner;
    };
  };

  # パスワードなしで kiosk のセッションを開く。cage モジュールが用意していた
  # PAM サービスの代替
  security.pam.services.sway-kiosk = {
    allowNullPassword = true;
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

  # Grafana のキオスク表示は数時間から数日で Chrome タブが OOM する既知問題があり、
  # 上流に修正の保証がない。リロードで復旧するので毎日作り直して回収する
  systemd.timers.kiosk-restart = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "04:00";
  };
  systemd.services.kiosk-restart = {
    serviceConfig.Type = "oneshot";
    script = "${config.systemd.package}/bin/systemctl restart sway-kiosk.service";
  };

  # カーネルコンソールのブランキングを止める。コンポジタとモニタ DPMS とは
  # 独立した層なので、これを残すと他を潰しても消灯する
  # 回転は sway 側 (output HDMI-A-1 transform 90) が担う。video= の rotate は
  # DRM 出力に効かないことが実機で確定したので付けない
  boot.kernelParams = [ "consoleblank=0" ];
}
