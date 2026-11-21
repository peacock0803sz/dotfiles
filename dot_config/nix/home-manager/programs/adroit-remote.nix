# Adroit のリモート作業マシン (Linux) 用。Mac の Adroit.app から pair して使う。
# 上流の `adroit remote enable` は current_exe() の /nix/store パスをユニットに書き込み、
# 更新や GC で壊れるため、同じ内容のユニット (crates/host/src/service.rs の systemd()) を宣言する。
# ユニット名も上流と揃えてあるので、`adroit remote enable` / `disable` は使わないこと。
# ログイン無しで動かすための linger は NixOS 側 (users.users.<name>.linger) で有効にする
{ pkgs, lib, config, inputs, ... }:
let
  adroit = inputs.adroit.packages.${pkgs.stdenv.hostPlatform.system}.default;
  home = config.home.homeDirectory;
in
{
  # `adroit remote pair` などを手で叩くので PATH にも入れる
  home.packages = [ adroit ];

  systemd.user.services.adroit-default-gateway = {
    Unit.Description = "Adroit gateway (default)";
    Service = {
      ExecStart = "${lib.getExe adroit} remote gateway --instance default";
      # 上流はログインシェルの PATH を写す。セッションで使う agent / git / jj を見つけられるよう fish と揃える
      Environment = "PATH=${lib.concatStringsSep ":" [
        "${home}/.local/bin"
        "${home}/dotfiles/bin"
        "/run/wrappers/bin"
        "${config.home.profileDirectory}/bin"
        "/nix/var/nix/profiles/default/bin"
        "/run/current-system/sw/bin"
      ]}";
      Restart = "always";
      RestartSec = 2;
      # 既定の control-group だと停止時に gateway が起動した host まで止まり、セッションが消える
      KillMode = "process";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
