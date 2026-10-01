{ config, lib, pkgs, ... }:
let
  # ストアパスで TCC の許可が記録されると再ビルドのたびに外れるため、bundle identifier で識別させる
  lemonadeApp = config.lib.appIdentity.mkAppBundle {
    package = pkgs.lemonade;
    identifier = "net.p3ac0ck.nix.lemonade";
  };
  lemonadeArgs = [
    lemonadeApp.mainExecutable
    "server"
    "--allow=0.0.0.0/0"
  ];
in
{
  launchd.user.agents.lemonade = {
    serviceConfig = {
      EnvironmentVariables = {
        LANG = "ja_JP.UTF-8";
        LC_ALL = "ja_JP.UTF-8";
      };
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path /nix/store && exec ${lib.escapeShellArgs lemonadeArgs}"
      ];
      KeepAlive = true;
      StandardErrorPath = "/tmp/lemonade.err.log";
      StandardOutPath = "/tmp/lemonade.out.log";
    };
  };
}
