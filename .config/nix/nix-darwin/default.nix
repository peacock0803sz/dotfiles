{ self, pkgs, system, username, ... }: {
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  users.users.${username}.home = "/Users/${username}";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    casks = import ./casks.nix;
  };

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;

    activationScripts.extraActivation.text = ''
      chsh -s ${pkgs.fish}/bin/fish
      softwareupdate --all --install
    '';

    defaults = {
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      LaunchServices.LSQuarantine = false;
      NSGlobalDomain.AppleShowAllExtensions = true;
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
      };
      dock = {
        autohide = true;
        show-recents = false;
        launchanim = false;
        orientation = "right";
      };
      trackpad = {
        Clicking = true;
        Dragging = true;
      };
    };
  };

  security = {
    sudo.extraConfig = ''
      ${username} ALL=(ALL) NOPASSWD: ALL
    '';
    pam.enableSudoTouchIdAuth = true;
  };
  nixpkgs.hostPlatform = system;

}
