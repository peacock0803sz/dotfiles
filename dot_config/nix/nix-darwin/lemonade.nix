{ lib, pkgs, ... }:
let
  lemonadeArgs = [
    "${pkgs.lemonade}/bin/lemonade"
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
