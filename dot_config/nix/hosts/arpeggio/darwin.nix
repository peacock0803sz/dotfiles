{ lib, ... }: {
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
}
