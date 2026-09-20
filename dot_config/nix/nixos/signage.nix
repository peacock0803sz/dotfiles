# bassoon に HDMI ディスプレイを繋いで Grafana を常時表示するサイネージ構成。
# 表示専用でありサーバ機能ではないので、grafana.nix とは分けてある。
{ config, pkgs, lib, ... }:
let
  # 同ホストの Grafana をループバックで引く。nginx と TLS と DNS を経由しないので、
  # 証明書失効や Cloudflare 障害や MagicDNS の不調があっても画面は映り続ける。
  # クエリ文字列は付けない。grafana-kiosk が KIOSK_MODE から ?kiosk=1 を、
  # KIOSK_AUTOFIT から &autofitpanels を自分で組み立てる
  url = "http://127.0.0.1:3001/d/kiosk/kiosk?from=now-3h&to=now";

  # Grafana の service account token。service account は provisioning に対応しないため
  # 宣言的に作れない。UI か API で発行して手置きする。
  # 存在しないと LoadCredential が失敗し cage-tty1 が起動を繰り返す
  tokenFile = "/var/lib/grafana-kiosk/token";

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
      # full は ?kiosk=1 に対応する。tv だとトップナビが残る
      KIOSK_MODE = "full";
      KIOSK_BROWSER_PATH = "${pkgs.chromium}/bin/chromium";
      # Xwayland を経由させず cage に直接描かせる
      KIOSK_OZONE_PLATFORM = "wayland";
      # キーボードもマウスも繋がないので、入力デバイス0台でも起動させる
      WLR_LIBINPUT_NO_DEVICES = "1";
    };
  };

  systemd.services.cage-tty1 = {
    # Grafana より先に開くとエラーページを掴んだまま止まる
    after = [ "grafana.service" "network-online.target" ];
    wants = [ "network-online.target" ];
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
  boot.kernelParams = [ "consoleblank=0" ];
}
