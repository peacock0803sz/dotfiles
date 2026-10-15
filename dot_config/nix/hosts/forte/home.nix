{ config, pkgs, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".ssh/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ssh/config.nixos";
  };
  home.packages = with pkgs; [
    bubblewrap
  ];

  # Let the CLI manage its shared daemon so remote-control start/stop/pair
  # continue to use the same instance as interactive Codex sessions.
  systemd.user.services.codex-remote-control = {
    Unit.Description = "Codex remote control daemon";
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = config.home.homeDirectory;
      Environment = "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin";
      ExecStart = "${config.home.profileDirectory}/bin/codex remote-control start";
      ExecStop = "${config.home.profileDirectory}/bin/codex remote-control stop";
      TimeoutStartSec = 120;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
