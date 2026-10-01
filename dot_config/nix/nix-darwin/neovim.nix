{ config, pkgs, username, ... }:
let
  # ストアパスで TCC の許可が記録されると再ビルドのたびに外れるため、bundle identifier で識別させる
  uvApp = config.lib.appIdentity.mkAppBundle {
    package = pkgs.uv;
    identifier = "net.p3ac0ck.nix.uv";
  };
in
{
  launchd.user.agents.neovim-log-rotator = {
    serviceConfig = {
      ProgramArguments = [
        uvApp.mainExecutable
        "run"
        "--script"
        "/Users/${username}/dotfiles/bin/neovim_log_rotator"
      ];
      StartCalendarInterval = [{ Hour = 2; Minute = 0; }];
      StandardErrorPath = "/tmp/neovim-log-rotator.err.log";
      StandardOutPath = "/tmp/neovim-log-rotator.out.log";
    };
  };
}
