{ pkgs, mcp-servers-nix, ... }:
let
  # nixpkgs の mcp が 2.x に上がって mcp-server-time / mcp-nixos が壊れたため、
  # mcp 1.x のままの mcp-servers-nix 側 nixpkgs で組んだものを使う。
  # NixOS/nixpkgs#563493 がマージされ、本体の nixpkgs で通るようになったら外す
  pinned = mcp-servers-nix.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.extend
    mcp-servers-nix.overlays.default;
in
{
  playwright = {
    enable = true;
    # macOS (darwin) ではシステムの Chrome を使用、NixOS では nixpkgs の chromium を使用
    executable =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      else "${pkgs.chromium}/bin/chromium";
  };
  github = {
    enable = true;
    passwordCommand = "echo \"GITHUB_PERSONAL_ACCESS_TOKEN=$(gh auth token)\"";
  };
  # bassoon の Grafana を tailnet 経由で参照する。
  # 用途はダッシュボード JSON の吸い出しと、パネルを書く前のメトリクス探索 / PromQL 検証
  grafana = {
    enable = true;
    # grafana.p3ac0ck.net の CNAME が Cloudflare 側に無く NXDOMAIN になるため
    # MagicDNS 名で直接引く。レコードを足したらこちらを正式名に戻すこと
    env.GRAFANA_URL = "https://bassoon.tail2121a.ts.net";
    # トークンは Nix store に置かない (store は誰でも読める)。各ホストに手置きする。
    # Grafana UI の Administration -> Service accounts で Viewer 権限のものを発行し、
    # ~/.config/mcp-grafana/token に mode 600 で保存する。
    # $HOME はラッパースクリプト実行時にシェルが展開する
    passwordCommand.GRAFANA_SERVICE_ACCOUNT_TOKEN = [ "cat" "$HOME/.config/mcp-grafana/token" ];
    args = [
      # 証明書は grafana.p3ac0ck.net 向けなので MagicDNS 名だと CN が一致しない。
      # tailnet 内の通信は WireGuard で暗号化済みなのでここは検証を落とす
      "--tls-skip-verify"
      # ダッシュボードは NixOS の provisioning で管理する方針なので API 経由では書かない。
      # (provisioning 済みダッシュボードへの API 更新は Grafana 自身が 412 で拒否する)
      "--disable-write"
    ];
  };
  terraform.enable = true;
  nixos = {
    enable = true;
    package = pinned.mcp-nixos;
  };
  time = {
    enable = true;
    package = pinned.mcp-server-time;
    args = [ "--local-timezone=Asia/Tokyo" ];
  };
}
