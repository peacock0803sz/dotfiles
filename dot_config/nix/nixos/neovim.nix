{ pkgs, username, ... }: {
  systemd.services.neovim-log-rotator = {
    description = "Rotate Neovim log files";
    serviceConfig = {
      Type = "oneshot";
      User = username;
      ExecStart = "${pkgs.uv}/bin/uv run --script /home/${username}/dotfiles/bin/neovim_log_rotator";
    };
  };

  systemd.timers.neovim-log-rotator = {
    description = "Timer for Neovim log rotation";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true;
    };
  };
}
