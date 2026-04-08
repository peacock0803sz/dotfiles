{ pkgs, username, ... }: {
  launchd.user.agents.neovim-log-rotator = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.uv}/bin/uv"
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
