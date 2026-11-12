{ lib, pkgs, username, ... }: {
  # nix store on external SSD: bypass the `/bin/sh -c "wait4path /nix/store && exec ..."`
  # wrapper so nix-daemon is a direct launchd child. macOS sandbox blocks dylib loading
  # from external volumes through indirect launchd children — see §7.4 of
  # ~/Downloads/nix-store-migration-guide.md.
  launchd.daemons.nix-daemon.serviceConfig = {
    ProgramArguments = lib.mkForce [
      "/nix/var/nix/profiles/default/bin/nix-daemon"
      "--daemon"
    ];
    KeepAlive = true;
    RunAtLoad = false;
  };

  nix.extraOptions = ''
    !include /etc/nix/gx-secrets.conf
  '';

  # ~/.orbstack/binのリンクが/Applications/OrbStack.appを指し、アプリも自己更新するのでbrew-nixではなくcaskで入れる
  homebrew.casks = [ "orbstack" ];

  # 隔離用の VM adlib。自動では起動せず、launchctl start net.p3ac0ck.nix.tart-adlib で起動する。
  # --net-softnet で LAN とホストへの通信を塞ぎ、ホストのディレクトリも共有しない。
  # softnet は passwordless sudo で自分を root に上げるので、nix store のまま SUID なしで動く
  launchd.user.agents.tart-adlib.serviceConfig = {
    ProgramArguments = [ "${pkgs.tart}/bin/tart" "run" "adlib" "--net-softnet" ];
    EnvironmentVariables = {
      # home.nix の TART_HOME と揃える
      TART_HOME = "/Volumes/Cache/tart";
      PATH = "${pkgs.softnet}/bin:/usr/bin:/bin";
    };
    StandardErrorPath = "/Users/${username}/Library/Logs/tart-adlib.log";
  };
}
